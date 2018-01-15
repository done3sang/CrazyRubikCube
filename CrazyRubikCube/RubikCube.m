//
//  RubikCube.m
//  CrazyRubikCube
//
//  Created by xy on 20/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "SceneNode.h"
#import "RubikCube.h"
#import "RubikBlock.h"
#import "RubikElement.h"
#import "GeometryMaker.h"
#import "GeometryMesh.h"
#import "Ray.h"
#import "PhysicsCollision.h"
#import "MathUtil.h"
#import "BoundingVolume.h"
#import "SphereBoundingVolume.h"
#import "Transform.h"
#import "RubikTouch.h"
#import "Director.h"
#import "Camera.h"

@implementation RubikCube

@synthesize dimension = _dimension;
@synthesize touchInside = _touchInside;

- (instancetype)initWithDimension:(size_t)dimension {
    if(self = [super init]) {
        [self setupRubik:dimension];
    }
    
    return self;
}

+ (RubikCube*)rubikWithDimension:(size_t)dimension {
    return [[RubikCube alloc] initWithDimension:dimension];
}

- (void)setupRubik:(size_t)dimension {
    _dimension = dimension;
    _halfSpan = (float)_dimension/2.0f;
    
    float halfCenter = _halfSpan - 0.5f;
    size_t cubeIndex = 0;
    GLKVector3 initPosition = GLKVector3Make(-halfCenter, -halfCenter, -halfCenter);
    GLKVector3 cubePosition;
    
    NSMutableArray *elementArray = [NSMutableArray array];
    
    // front-bottom -> back-top
    for(unsigned int zIndex = 0; zIndex != dimension; ++zIndex) {
        cubePosition.z = initPosition.z + (float)zIndex;
        for(unsigned int yIndex = 0; yIndex != dimension; ++yIndex) {
            cubePosition.y = initPosition.y + (float)yIndex;
            for(unsigned int xIndex = 0; xIndex != dimension; ++xIndex) {
                cubePosition.x = initPosition.x + (float)xIndex;
                
                RubikElement *elem = [RubikElement rubikElement:cubeIndex elementPosition:cubePosition];
                
                [elementArray addObject:elem];
                ++cubeIndex;
            }
        }
    }
    
    // block
    RubikBlock *aBlock = [RubikBlock blockWithBlock:RubikBlockOrientationNone
                                      blockPosition:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                         blockIndex:0
                                          blockSize:_dimension
                                     blockDimension:_dimension
                                         blockArray:elementArray];
    
    [self attachChild:aBlock];
    
    // bounding box
    _boundingVolume = [SphereBoundingVolume sphereWithSphere:_transform.position
                                                      radius:1.732050f * _halfSpan];
    
    // wood matrix
    _woodSliceMatrix = GLKMatrix4Rotate(GLKMatrix4Identity,
                                        GLKMathDegreesToRadians(10.0f),
                                        1.0f, 0.0f, 0.0f);
    _woodSliceMatrix = GLKMatrix4Rotate(_woodSliceMatrix,
                                        GLKMathDegreesToRadians(-20.0f),
                                        0.0f, 0.0f, 1.0f);
    _woodSliceMatrix = GLKMatrix4Scale(_woodSliceMatrix,
                                       10.0f, 10.0f, 1.0f);
    _woodSliceMatrix = GLKMatrix4Translate(_woodSliceMatrix,
                                           -0.35f, -0.5f, 2.0f);
    
    _woodDarkColor  = GLKVector4Make(0.8f, 0.5f, 0.1f, 1.0f);
    _woodLightColor = GLKVector4Make(1.0f, 0.75f, 0.25f, 1.0f);
    
    // geometry mesh
    _geometry = [[GeometryMaker sharedGeometryMaker] geometryMeshByName:@"roundCube"];
    [_geometry prepareToRender];
    [_geometry uniformVector4:"darkWoodColor" uniformVector:_woodDarkColor];
    [_geometry uniformVector4:"lightWoodColor" uniformVector:_woodLightColor];
    [_geometry uniformMatrix4:"woodSliceMatrix" uniformMatrix:_woodSliceMatrix];
    
    // touches
    _rubikTouches = [NSMutableArray array];
    _touchInside = NO;
}

- (BOOL)processTouchBegan:(NSSet<UITouch *> *)touches {
    for (UITouch *touch in touches) {
        [self pushTouch:touch];
    }
    
    return YES;
}

- (BOOL)processTouchMoved:(NSSet<UITouch *> *)touches {
    return YES;
}

- (BOOL)processTouchEnded:(NSSet<UITouch *> *)touches {
    for (UITouch *touch in touches) {
        //[self popTouch:touch];
    }
     
    return YES;
}

- (BOOL)processTouchCancelled:(NSSet<UITouch *> *)touches {
    for (UITouch *touch in touches) {
        //[self popTouch:touch];
    }
    
    return YES;
}

- (BOOL)processTapGesture:(nonnull UITapGestureRecognizer*)gesture {
    if(UIGestureRecognizerStateEnded == gesture.state) {
        [self popAllTouches];
    }
    
    return YES;
}

- (BOOL)processLongPressGesture:(nonnull UILongPressGestureRecognizer*)gesture {
    if(UIGestureRecognizerStateEnded == gesture.state) {
        [self popAllTouches];
    }
    
    return YES;
}

- (BOOL)processPinchGesture:(nonnull UIPinchGestureRecognizer*)gesture {
    if(UIGestureRecognizerStateEnded == gesture.state) {
        [self popAllTouches];
    }
    
    return YES;
}

- (BOOL)processRotationGesture:(nonnull UIRotationGestureRecognizer*)gesture {
    if(UIGestureRecognizerStateChanged == gesture.state) {
        float rv = gesture.rotation;
        
        if(!_touchInside) {
            GLKMatrix4 rm = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-rv),
                                                           0.0f, 0.0f, 1.0f);
            _transform.extraMatrix = GLKMatrix4Multiply(rm, _transform.extraMatrix);
        }
    }
    
    if(UIGestureRecognizerStateEnded == gesture.state) {
        [self popAllTouches];
    }
    
    return YES;
}

- (BOOL)processPanGesture:(nonnull UIPanGestureRecognizer*)gesture {
    if(UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint translation = [gesture translationInView:nil];
        float tx = translation.x;// * [UIScreen mainScreen].scale;
        float ty = translation.y;// * [UIScreen mainScreen].scale;
        float tv = tx;
        GLKVector3 axis = GLKVector3Make(0.0f, 1.0f, 0.0f);
        
        if(fabsf(tx) < fabsf(ty)) {
            tv = ty;
            axis = GLKVector3Make(1.0f, 0.0f, 0.0f);
        }
        
        tv *= 0.01f;
        
        if(!_touchInside) {
            GLKMatrix4 axisMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(tv),
                                                       axis.x, axis.y, axis.z);
            _transform.extraMatrix = GLKMatrix4Multiply(axisMatrix, _transform.extraMatrix);
        } else {
            GLKVector2 screenVec = GLKVector2Make(tx, ty);
            GLKVector3 worldVec = [[Director sharedDirector].mainCamera pickupDirectionAtScreen:screenVec];
            RubikTouch *touch = [self mainTouch];
            
            if(touch) {
                RubikBlock *block = touch.touchedBlock;
                
                [block doPanBlock:touch worldTranslation:worldVec];
            }
        }
    }
    
    if(UIGestureRecognizerStateEnded == gesture.state) {
        [self popAllTouches];
    }
    
    return YES;
}

- (BOOL)processSwipeGesture:(nonnull UISwipeGestureRecognizer*)gesture {
    if(UIGestureRecognizerStateEnded == gesture.state) {
        [self popAllTouches];
    }
    
    return YES;
}

- (void)movedTouches:(nonnull NSSet<UITouch*>*)touches {
    if(_touchInside) {
        [self movedTouchesInside:touches];
    } else {
        [self movedTouchesOutside:touches];
    }
}

- (void)movedTouchesInside:(nonnull NSSet<UITouch*>*)touches {
    if(2 < _rubikTouches.count) {
        NSLog(@"Warning: RubikCube.movedTouchesInside fingers %lu, undefined", (unsigned long)_rubikTouches.count);
        return;
    }
}

- (void)movedTouchesOutside:(nonnull NSSet<UITouch*>*)touches {
    if(2 < _rubikTouches.count) {
        NSLog(@"Warning: movedTouchesOutside fingers %lu, undefined", (unsigned long)_rubikTouches.count);
        return;
    }
    
    NSArray *touchArr = [touches allObjects];
    
    if(1 == _rubikTouches.count) {
        UITouch *touch = [touchArr objectAtIndex:0];
        GLKVector2 previousLocation = [self previousLocationInRubik:touch];
        GLKVector2 currentLocation = [self locationInRubik:touch];
        
        [self doRubikSwip:GLKVector2Subtract(currentLocation, previousLocation)];
    }
}

- (void)doRubikSwip:(GLKVector2)offset {
    
}

- (void)overTouches {
    
}

- (RubikTouch*)mainTouch {
    return 0 == _rubikTouches.count ? nil: [_rubikTouches objectAtIndex:0];
}

- (void)pushTouch:(nonnull UITouch*)touch {
    if(0 < _rubikTouches.count) {
        [_rubikTouches addObject:touch];
        return;
    }
    
    [_rubikTouches addObject:[self touch2RubikTouch:touch isTouched:&_touchInside]];
}

- (RubikTouch*)touch2RubikTouch:(nonnull UITouch*)touch isTouched:(nonnull BOOL*)touched {
    GLKVector2 pos = [self locationInRubik:touch];
    Ray *ray = [[Director sharedDirector].mainCamera pickupRayAtScreen:pos];
    ray.origin = [_transform world2LocalDirection:ray.origin];
    ray.direction = [_transform world2LocalDirection:ray.direction];
    
    GLKVector3 intersection = GLKVector3Make(0.0f, 0.0f, 0.0f);
    RubikTouch *rt = [RubikTouch rubikTouchWithTouch:touch intersection:intersection];
    
    *touched = NO;
    if([PhysicsCollision testRaySphere:ray sphere:_boundingVolume]) {
        for (RubikBlock *block in _children) {
            if([block intersectRayAndBlock:ray intersectionPoint:&intersection]) {
                rt.touchedBlock = block;
                rt.intersection = intersection;
                
                *touched = YES;
                break;
            }
        }
    }
    
    return rt;
}

- (void)popTouch:(nonnull UITouch*)touch {
    NSAssert(0 < _rubikTouches.count, @"ERROR: RubikCube.popTouch, empty");
    
    RubikTouch *mainTouch = [_rubikTouches objectAtIndex:0];
    
    if(1 == _rubikTouches.count) {
        NSAssert([mainTouch isEqualToUITouch:touch], @"ERROR: RubikCube.popTouch, wrong");
        
        [_rubikTouches removeAllObjects];
        [self overTouches];
        return;
    }
    
    if([mainTouch isEqualToUITouch:touch]) {
        RubikTouch *secondTouch = [self touch2RubikTouch:[_rubikTouches objectAtIndex:1] isTouched:&_touchInside];
        [_rubikTouches replaceObjectAtIndex:0 withObject:secondTouch];
        [_rubikTouches removeObjectAtIndex:1];
        return;
    }
    
    [_rubikTouches removeObject:touch];
}

- (void)popAllTouches {
    [_rubikTouches removeAllObjects];
}

- (GLKVector2)previousLocationInRubik:(nonnull UITouch*)touch {
    CGPoint location = [touch preciseLocationInView:nil];
    float uiScale = [UIScreen mainScreen].scale;
    
    return GLKVector2Make(location.x * uiScale, location.y * uiScale);
}

- (GLKVector2)locationInRubik:(nonnull UITouch*)touch {
    CGPoint location = [touch locationInView:nil];
    float uiScale = [UIScreen mainScreen].scale;
    
    return GLKVector2Make(location.x * uiScale, location.y * uiScale);
}

@end
