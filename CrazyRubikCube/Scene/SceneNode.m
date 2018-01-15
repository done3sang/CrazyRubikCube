//
//  SceneNode.m
//  CrazyRubikCube
//
//  Created by xy on 23/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import "GeometryMesh.h"
#import "SceneNode.h"
#import "Transform.h"

@implementation SceneNode

@synthesize transform = _transform;
@synthesize geometry = _geometry;
@synthesize parent = _parent;

- (instancetype)init {
    if(self = [super init]) {
        [self initSceneNode];
    }
    
    return self;
}

+ (SceneNode*)nodeWithIdentity {
    return [[SceneNode alloc] init];
}

- (NSString*)className {
    return @"SceneNode";
}

- (void)initSceneNode {
    _transform  = [Transform transformWithIdentity];
    _geometry   = nil;
    _parent     = nil;
    _children   = [[NSMutableArray alloc] init];
}

- (BOOL)hasChild:(SceneNode*)childNode {
    return (nil != childNode) && (NSNotFound != [_children indexOfObjectIdenticalTo:childNode]);
}

- (GLKMatrix4)node2WorldMatrix {
    GLKMatrix4 mm = [_transform local2WorldMatrix];
    SceneNode *node = _parent;
    
    while(nil != node) {
        mm = GLKMatrix4Multiply(node.transform.local2WorldMatrix, mm);
        node = node.parent;
    }
    
    return mm;
}

- (GLKMatrix4)world2NodeMatrix {
    /*
    GLKMatrix4 mm = [_transform world2LocalMatrix];
    SceneNode *node = _parent;
    
    while(nil != node) {
        mm = GLKMatrix4Multiply(mm, node.transform.world2LocalMatrix);
        node = node.parent;
    }
    
    return mm;
     */
    return GLKMatrix4Invert([self node2WorldMatrix], NULL);
}

- (GLKVector3)node2WorldPoint:(GLKVector3)point {
    return GLKMatrix4MultiplyVector3([self node2WorldMatrix], point);
}

- (GLKVector3)node2WorldDirection:(GLKVector3)direction {
    return GLKMatrix4MultiplyVector3([self node2WorldMatrix], direction);
}

- (GLKVector3)world2NodePoint:(GLKVector3)point {
    return GLKMatrix4MultiplyVector3([self world2NodeMatrix], point);
}

- (GLKVector3)world2NodeDirection:(GLKVector3)direction {
    return GLKMatrix4MultiplyVector3([self world2NodeMatrix], direction);
}

- (void)attachChild:(SceneNode *)childNode {
    NSAssert(nil != childNode, @"SceneNode.attachNode cannot accept nil");
    
    if([self hasChild:childNode]) {
        NSAssert(childNode.parent == self,
                 @"SceneNode.attachNode going wrong between nodes");
        return;
    }
    
    if(childNode.parent) {
        [childNode detachFromParent];
        
        // convert child node to node space, then attach it
        GLKMatrix4 mat = [self world2NodeMatrix];
        mat = GLKMatrix4Multiply(mat, [childNode node2WorldMatrix]);
        [childNode.transform transformWithMatrix:mat];
    }
    
    childNode.parent = self;
    [_children addObject:childNode];
}

- (void)detachChild:(SceneNode *)childNode {
    NSAssert(childNode != nil, @"SceneNode.detachChild cannot accept nil");
    NSAssert(childNode.parent && childNode.parent == self,
             @"SceneNode.detachChild going wrong between nodes");
    
    NSUInteger childIndex = [_children indexOfObjectIdenticalTo:childNode];
    
    NSAssert(childIndex != NSNotFound, @"SceneNode.detachChild going wrong between nodes");
    if(NSNotFound == childIndex) {
        return;
    }
    
    // convert child node to world space, then detach it
    GLKMatrix4 mat = [childNode node2WorldMatrix];
    [childNode.transform transformWithMatrix:mat];
    
    [_children removeObjectAtIndex:childIndex];
    childNode.parent = nil;
}

- (void)detachFromParent {
    if(nil != _parent) {
        [_parent detachChild:self];
    }
}

- (size_t)childrenCount {
    return _children.count;
}

- (SceneNode*)getChild:(size_t)index {
    NSAssert(index < [self childrenCount], @"ERROR: SceneNode.getChild, argument WRONG");
    
    return [_children objectAtIndex:index];
}

- (void)detachAllChildren {
    for (SceneNode* child in _children) {
        [child detachFromParent];
    }
    
    [_children removeAllObjects];
}

- (void)moveAllChildrenToAnother:(SceneNode *)anotherNode {
    NSAssert(nil != anotherNode, @"moveAllChildrenToAnother cannot accept nil");
    
    for (SceneNode *child in _children) {
        if(child != anotherNode) {
            [anotherNode attachChild:child];
        }
    }
}

- (void)update:(float)deltaTime {
    [self updateSelf:deltaTime];
    
    for (SceneNode *child in _children) {
        [child update:deltaTime];
    }
}

- (void)render:(GLKMatrix4)outerMatrix {
    outerMatrix = GLKMatrix4Multiply(outerMatrix, [_transform local2WorldMatrix]);
    
    [self renderSelf:outerMatrix];
    
    for (SceneNode *child in _children) {
        [child render:outerMatrix];
    }
}

- (void)updateSelf:(float)deltaTime {
    
}

- (void)renderSelf:(GLKMatrix4)modelMatrix {
    
}

#pragma mark handle touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([self processTouchBegan:touches]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([self processTouchMoved:touches]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([self processTouchMoved:touches]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([self processTouchCancelled:touches]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child touchesCancelled:touches withEvent:event];
    }
}

- (BOOL)processTouchBegan:(nonnull NSSet<UITouch *> *)touch {
    return NO;
}

- (BOOL)processTouchMoved:(nonnull NSSet<UITouch *> *)touches {
    return NO;
}

- (BOOL)processTouchEnded:(nonnull NSSet<UITouch *> *)touches {
    return NO;
}

- (BOOL)processTouchCancelled:(nonnull NSSet<UITouch *> *)touches {
    return NO;
}

#pragma mark handle gestures

- (void)tapGesture:(nonnull UITapGestureRecognizer*)gesture {
    if([self processTapGesture:gesture]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child tapGesture:gesture];
    }
}

- (void)longPressGesture:(nonnull UILongPressGestureRecognizer*)gesture {
    if([self processLongPressGesture:gesture]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child longPressGesture:gesture];
    }
}

- (void)pinchGesture:(nonnull UIPinchGestureRecognizer*)gesture {
    if([self processPinchGesture:gesture]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child pinchGesture:gesture];
    }
}

- (void)rotationGesture:(nonnull UIRotationGestureRecognizer*)gesture {
    if([self processRotationGesture:gesture]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child rotationGesture:gesture];
    }
}

- (void)panGesture:(nonnull UIPanGestureRecognizer*)gesture {
    if([self processPanGesture:gesture]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child panGesture:gesture];
    }
}

- (void)swipeGesture:(nonnull UISwipeGestureRecognizer*)gesture {
    if([self processSwipeGesture:gesture]) {
        return;
    }
    
    for (SceneNode *child in _children) {
        [child swipeGesture:gesture];
    }
}

- (BOOL)processTapGesture:(nonnull UITapGestureRecognizer*)gesture {
    return NO;
}

- (BOOL)processLongPressGesture:(nonnull UILongPressGestureRecognizer*)gesture {
    return NO;
}

- (BOOL)processPinchGesture:(nonnull UIPinchGestureRecognizer*)gesture {
    return NO;
}

- (BOOL)processRotationGesture:(nonnull UIRotationGestureRecognizer*)gesture {
    return NO;
}

- (BOOL)processPanGesture:(nonnull UIPanGestureRecognizer*)gesture {
    return NO;
}

- (BOOL)processSwipeGesture:(nonnull UISwipeGestureRecognizer*)gesture {
    return NO;
}

@end
