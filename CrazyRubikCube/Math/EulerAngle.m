//
//  EulerAngle.m
//  CrazyRubikCube
//
//  Created by Sang on 1/2/17.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "EulerAngle.h"
#import "MathUtil.h"

@implementation EulerAngle

@synthesize heading = _heading;
@synthesize pitch = _pitch;
@synthesize bank = _bank;

- (instancetype)init {
    if(self = [super init]) {
        [self identity];
    }
    
    return self;
}

- (instancetype)initFromInertia2ObjectMatrix:(const GLKMatrix4)innerMatrix {
    if(self = [super init]) {
        [self doFromInertia2ObjectMatrix:innerMatrix];
    }
    
    return self;
}

- (instancetype)initFromObject2InertiaMatrix:(const GLKMatrix4)outerMatrix {
    if(self = [super init]) {
        [self doFromObject2InertiaMatrix:outerMatrix];
    }
    
    return self;
}

+ (EulerAngle*)eulerAngleWithIdentity {
    return [[EulerAngle alloc] init];
}

+ (EulerAngle*)eulerAngleFromInertia2ObjectMatrix:(const GLKMatrix4)innerMatrix {
    return [[EulerAngle alloc] initFromInertia2ObjectMatrix:innerMatrix];
}

+ (EulerAngle*)eulerAngleFromObject2InertiaMatrix:(const GLKMatrix4)outerMatrix {
    return [[EulerAngle alloc] initFromObject2InertiaMatrix:outerMatrix];
}

- (void)doFromInertia2ObjectMatrix:(const GLKMatrix4)innerMatrix {
    float sinp = -innerMatrix.m[6];
    
    if(1.0f - kEpsilon < fabsf(sinp)) {
        _heading = atan2f(-innerMatrix.m[8], innerMatrix.m[0]);
        _pitch = kPiOver2 * sinp;
        _bank = 0.0f;
    } else {
        _heading = atan2f(innerMatrix.m[2], innerMatrix.m[10]);
        _pitch = [MathUtil safeAsin:sinp];
        _bank = atan2f(innerMatrix.m[4], innerMatrix.m[5]);
    }
    
    _dirty = YES;
}

- (void)doFromObject2InertiaMatrix:(const GLKMatrix4)outerMatrix {
    float sinp = -outerMatrix.m[9];
    
    if(1.0f - kEpsilon < fabsf(sinp)) {
        _heading = atan2f(-outerMatrix.m[2], outerMatrix.m[0]);
        _pitch = kPiOver2 * sinp;
        _bank = 0.0f;
    } else {
        _heading = atan2f(outerMatrix.m[8], outerMatrix.m[10]);
        _pitch = [MathUtil safeAsin:sinp];
        _bank = atan2f(outerMatrix.m[1], outerMatrix.m[5]);
    }
    
    _dirty = YES;
}

- (void)canonize {
    _pitch = [MathUtil wrapPi:_pitch];
    
    if(_pitch < -kPiOver2) {
        _pitch = -kPi - _pitch;
        _heading += kPi;
        _bank += kPi;
    } else if(_pitch > kPiOver2) {
        _pitch = kPi - _pitch;
        _heading += kPi;
        _bank += kPi;
    }
    
    if(kPiOver2 - kEpsilon < fabs(_pitch)) {
        _heading += _bank;
        _bank = 0.0f;
    } else {
        _bank = [MathUtil wrapPi:_bank];
    }
    
    _heading = [MathUtil wrapPi:_heading];
}

- (void)identity {
    _heading = _pitch = _bank = 0.0f;
    _dirty = YES;
}

- (void)setHeading:(float)heading {
    _heading = heading;
    _dirty = YES;
}

- (void)setPitch:(float)pitch {
    _pitch = pitch;
    _dirty = YES;
}

- (void)setBank:(float)bank {
    _bank = bank;
    _dirty = YES;
}

- (GLKMatrix4)inertia2ObjectMatrix {
    [self updateEuler];
    
    return _inertia2ObjectMatrix;
}

- (GLKMatrix4)object2InertiaMatrix {
    [self updateEuler];
    
    return _object2InertiaMatrix;
}

- (void)updateMatrix {
    GLKMatrix4 bankMatrix       = GLKMatrix4MakeZRotation(-_bank);
    GLKMatrix4 pitchMatrix      = GLKMatrix4MakeXRotation(-_pitch);
    GLKMatrix4 headingMatrix    = GLKMatrix4MakeYRotation(-_heading);
    
    _inertia2ObjectMatrix = GLKMatrix4Multiply(bankMatrix, pitchMatrix);
    _inertia2ObjectMatrix = GLKMatrix4Multiply(_inertia2ObjectMatrix, headingMatrix);
    
    headingMatrix = GLKMatrix4MakeYRotation(_heading);
    pitchMatrix = GLKMatrix4MakeXRotation(_pitch);
    bankMatrix = GLKMatrix4MakeZRotation(_bank);
    
    _object2InertiaMatrix = GLKMatrix4Multiply(headingMatrix, pitchMatrix);
    _object2InertiaMatrix = GLKMatrix4Multiply(_object2InertiaMatrix, bankMatrix);
}

- (void)updateEuler {
    if(!_dirty) {
        return;
    }
    
    [self canonize];
    [self updateMatrix];
}

- (id)copyWithZone:(NSZone *)zone {
    return [EulerAngle eulerAngleFromInertia2ObjectMatrix:_inertia2ObjectMatrix];
}

@end
