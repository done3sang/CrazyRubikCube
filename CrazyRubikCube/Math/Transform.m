//
//  Transform.m
//  CrazyRubikCube
//
//  Created by xy on 09/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "Transform.h"
#import "EulerAngle.h"

@implementation Transform

@synthesize position = _position;
@synthesize scale = _scale;
@synthesize eulerAngle = _eulerAngle;

- (instancetype)init {
    if(self = [super init]) {
        [self initTransform];
    }
    
    return self;
}

- (instancetype)initWithPosition:(GLKVector3)position {
    if(self = [super init]) {
        [self initTransformWithPosition:position];
    }
    
    return self;
}

- (void)initTransform {
    _position = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _scale = GLKVector3Make(1.0f, 1.0f, 1.0f);
    _eulerAngle = [EulerAngle eulerAngleWithIdentity];
    _extraMatrix = GLKMatrix4Identity;
    _dirty = YES;
}

- (void)initTransformWithPosition:(GLKVector3)position {
    [self initTransform];
    _position = position;
}

+ (Transform*)transformWithIdentity {
    return [[Transform alloc] init];
}

+ (Transform*)transformWithPosition:(GLKVector3)position {
    return [[Transform alloc] initWithPosition:position];
}

- (void)identity {
    [_eulerAngle identity];
    _dirty = YES;
}

- (void)setPosition:(GLKVector3)position {
    _position = position;
    _dirty = YES;
}

- (void)setScale:(GLKVector3)scale {
    _scale = scale;
}

- (void)setXRotation:(float)xRotation {
    _eulerAngle.pitch = xRotation;
    _dirty = YES;
}

- (float)xRotation {
    return _eulerAngle.pitch;
}

- (void)setYRotation:(float)yRotation {
    _eulerAngle.heading = yRotation;
    _dirty = YES;
}

- (float)yRotation {
    return _eulerAngle.heading;
}

- (void)setZRotation:(float)zRotation {
    _eulerAngle.bank = zRotation;
    _dirty = YES;
}

- (float)zRotation {
    return _eulerAngle.bank;
}

- (GLKMatrix4)local2WorldMatrix {
    [self updateMatrix];
    
    return _local2WorldMatrix;
}

- (GLKMatrix4)world2LocalMatrix {
    [self updateMatrix];
    
    return _world2LocalMatrix;
}

- (GLKMatrix4)modelMatrix {
    [self updateMatrix];
    
    return _modelMatrix;
}

- (void)setExtraMatrix:(GLKMatrix4)extraMatrix {
    _extraMatrix = extraMatrix;
    _dirty = YES;
}

- (GLKMatrix4)extraMatrix {
    return _extraMatrix;
}

- (void)updateMatrix {
    if(!_dirty) {
        return;
    }
    
    _local2WorldMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(_position.x, _position.y, _position.z), _eulerAngle.object2InertiaMatrix);
    //_world2LocalMatrix = GLKMatrix4Multiply(_eulerAngle.inertia2ObjectMatrix, GLKMatrix4MakeTranslation(-_position.x, -_position.y, -_position.z));
    //_modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeScale(_scale.x, _scale.y, _scale.z), _local2WorldMatrix);
    
    _local2WorldMatrix = GLKMatrix4Multiply(_extraMatrix, _local2WorldMatrix);
    _world2LocalMatrix = GLKMatrix4Invert(_local2WorldMatrix, NULL);
    _modelMatrix = GLKMatrix4Multiply(GLKMatrix4MakeScale(_scale.x, _scale.y, _scale.z), _local2WorldMatrix);
    
    _dirty = NO;
}

- (void)translate:(GLKVector3)offset {
    _position = GLKVector3Add(_position, offset);
    _dirty = YES;
}

- (GLKVector3)local2WorldPoint:(GLKVector3)point {
    return GLKMatrix4MultiplyVector3(self.local2WorldMatrix, point);
}

- (GLKVector3)local2WorldDirection:(GLKVector3)direction {
    return GLKMatrix4MultiplyVector3(_eulerAngle.object2InertiaMatrix, direction);
}

- (GLKVector3)world2LocalPoint:(GLKVector3)point {
    GLKVector4 position = GLKMatrix4MultiplyVector4(self.world2LocalMatrix, GLKVector4MakeWithVector3(point, 1.0f));
    position = GLKVector4DivideScalar(position, position.w);
    
    return GLKVector3Make(position.x, position.y, position.z);
}

- (GLKVector3)world2LocalDirection:(GLKVector3)direction {
    return GLKMatrix4MultiplyVector3(_eulerAngle.inertia2ObjectMatrix, direction);
}

- (void)transformWithMatrix:(GLKMatrix4)mat {
    GLKVector4 pos = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    pos = GLKMatrix4MultiplyVector4(mat, pos);
    pos = GLKVector4DivideScalar(pos, pos.w);
    _position = GLKVector3Make(pos.x, pos.y, pos.z);
    
    
    [_eulerAngle doFromObject2InertiaMatrix:mat];
    _dirty = YES;
}

- (id)copyWithZone:(NSZone *)zone {
    Transform *t = [Transform transformWithIdentity];
    t.position = _position;
    t.scale = _scale;
    t.eulerAngle = [_eulerAngle copyWithZone:zone];
    
    return t;
}

@end
