//
//  SceneNode.h
//  CrazyRubikCube
//
//  Created by xy on 23/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Transform;
@class GeometryMesh;
@class BoundingVolume;

@interface SceneNode : NSObject {
    Transform *_transform;
    GeometryMesh *_geometry;
    
    __weak SceneNode *_parent;
    NSMutableArray *_children;
}

@property (nonatomic, strong, nonnull) Transform *transform;
@property (nonatomic, strong, nullable) GeometryMesh *geometry;
@property (nonatomic, weak, nullable) SceneNode* parent;
@property (nonatomic, assign) GLKMatrix4 extraMatrix;

- (nonnull instancetype)init;

+ (nonnull SceneNode*)nodeWithIdentity;

- (nonnull NSString*)className;

- (void)update:(float)deltaTime;

- (void)render:(GLKMatrix4)outerMatrix;

- (void)updateSelf:(float)deltaTime;

- (void)renderSelf:(GLKMatrix4)modelMatrix;

- (void)attachChild:(nonnull SceneNode*)childNode;

- (void)detachChild:(nonnull SceneNode*)childNode;

- (void)detachFromParent; // convert node to world space, then detach

- (size_t)childrenCount;

- (nonnull SceneNode*)getChild:(size_t)index;

- (void)detachAllChildren;

- (void)moveAllChildrenToAnother:(nonnull SceneNode*)anotherNode;

- (GLKMatrix4)world2NodeMatrix;

- (GLKMatrix4)node2WorldMatrix;

- (GLKVector3)node2WorldPoint:(GLKVector3)point;

- (GLKVector3)node2WorldDirection:(GLKVector3)direction;

- (GLKVector3)world2NodePoint:(GLKVector3)point;

- (GLKVector3)world2NodeDirection:(GLKVector3)direction;

# pragma mark handle touches

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nonnull UIEvent *)event;

- (void)touchesMoved:(nonnull NSSet<UITouch *> *)touches withEvent:(nonnull UIEvent *)event;

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nonnull UIEvent *)event;

- (void)touchesCancelled:(nonnull NSSet<UITouch *> *)touches withEvent:(nonnull UIEvent *)event;

- (BOOL)processTouchBegan:(nonnull NSSet<UITouch *> *)touch;

- (BOOL)processTouchMoved:(nonnull NSSet<UITouch *> *)touches;

- (BOOL)processTouchEnded:(nonnull NSSet<UITouch *> *)touches;

- (BOOL)processTouchCancelled:(nonnull NSSet<UITouch *> *)touches;

#pragma mark gesture

- (void)tapGesture:(nonnull UITapGestureRecognizer*)gesture;

- (void)longPressGesture:(nonnull UILongPressGestureRecognizer*)gesture;

- (void)pinchGesture:(nonnull UIPinchGestureRecognizer*)gesture;

- (void)rotationGesture:(nonnull UIRotationGestureRecognizer*)gesture;

- (void)panGesture:(nonnull UIPanGestureRecognizer*)gesture;

- (void)swipeGesture:(nonnull UISwipeGestureRecognizer*)gesture;

- (BOOL)processTapGesture:(nonnull UITapGestureRecognizer*)gesture;

- (BOOL)processLongPressGesture:(nonnull UILongPressGestureRecognizer*)gesture;

- (BOOL)processPinchGesture:(nonnull UIPinchGestureRecognizer*)gesture;

- (BOOL)processRotationGesture:(nonnull UIRotationGestureRecognizer*)gesture;

- (BOOL)processPanGesture:(nonnull UIPanGestureRecognizer*)gesture;

- (BOOL)processSwipeGesture:(nonnull UISwipeGestureRecognizer*)gesture;

@end
