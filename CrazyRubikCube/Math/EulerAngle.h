//
//  EulerAngle.h
//  CrazyRubikCube
//
//  Created by Sang on 1/2/17.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface EulerAngle : NSObject<NSCopying> {
    float _heading; // y-axis
    float _pitch; // x-axis
    float _bank; // z-axis
    
    GLKMatrix4 _object2InertiaMatrix;
    GLKMatrix4 _inertia2ObjectMatrix;
    BOOL _dirty;
}

@property (nonatomic, assign) float heading;
@property (nonatomic, assign) float pitch;
@property (nonatomic, assign) float bank;

@property (nonatomic, readonly) GLKMatrix4 object2InertiaMatrix;
@property (nonatomic, readonly) GLKMatrix4 inertia2ObjectMatrix;

- (instancetype)initFromInertia2ObjectMatrix:(const GLKMatrix4)innerMatrix;

- (instancetype)initFromObject2InertiaMatrix:(const GLKMatrix4)outerMatrix;

+ (EulerAngle*)eulerAngleWithIdentity;

+ (EulerAngle*)eulerAngleFromInertia2ObjectMatrix:(const GLKMatrix4)innerMatrix;

+ (EulerAngle*)eulerAngleFromObject2InertiaMatrix:(const GLKMatrix4)outerMatrix;

- (void)doFromInertia2ObjectMatrix:(const GLKMatrix4)innerMatrix;

- (void)doFromObject2InertiaMatrix:(const GLKMatrix4)outerMatrix;

- (void)canonize;

- (void)identity;

- (GLKMatrix4)inertia2ObjectMatrix;

- (GLKMatrix4)object2InertiaMatrix;

- (id)copyWithZone:(NSZone *)zone;

@end
