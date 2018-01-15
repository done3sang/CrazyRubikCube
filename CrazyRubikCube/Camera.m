//
//  Camera.m
//  CrazyRubikCube
//
//  Created by xy on 06/02/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "Camera.h"
#import "Ray.h"

@implementation Camera

@synthesize eye = _eye;
@synthesize lookAt = _lookAt;
@synthesize viewMatrix = _viewMatrix;
@synthesize projectionMatrix = _projectionMatrix;

static id _mainCamera = nil;

+ (Camera*)mainCamera {
    if(nil == _mainCamera) {
        _mainCamera = [[Camera alloc] initWithView:GLKVector3Make(0.0f, 5.0f, 5.0f)
                                            lookAt:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    }
    
    return _mainCamera;
}

- (instancetype)init {
    if(self = [super init]) {
        [self initCamera:GLKVector3Make(0.0f, 0.0f, 1.0f)
                  lookAt:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    }
    
    return self;
}

- (instancetype)initWithView:(GLKVector3)eye lookAt:(GLKVector3)lookAt {
    if(self = [super init]) {
        [self initCamera:eye lookAt:lookAt];
    }
    
    return self;
}

- (GLKMatrix4)viewProjectionMatrix {
    return GLKMatrix4Multiply(_projectionMatrix, _viewMatrix);
}

- (void)update:(float)deltaTime {
    [self updateCamera];
}

- (void)render {
    
}

- (bool)pickupPointAtScreen:(GLKVector2)screenPoint farPlanePoint:(GLKVector3*)farPoint {
    bool status;
    
    GLKVector3 fp = GLKMathUnproject(GLKVector3Make(screenPoint.x, _viewport[3] - screenPoint.y, 1.0f),
                                     _viewMatrix, _projectionMatrix, _viewport, &status);
    
    if(farPoint) {
        *farPoint = fp;
    }
    
    return status;
}

- (Ray*)pickupRayAtScreen:(GLKVector2)screenPoint {
    GLKVector3 rayOrg = _eye;
    GLKVector3 rayDir = _lookAt;
    GLKVector3 farPoint;

    if([self pickupPointAtScreen:screenPoint farPlanePoint:&farPoint]) {
        rayDir = GLKVector3Normalize(GLKVector3Subtract(farPoint, rayOrg));
    } else {
        NSAssert(NO, @"WARING:pickupRayAtScreen failed");
    }
    
    return [Ray rayWithRay:rayOrg direction:rayDir];
}

- (GLKVector3)pickupDirectionAtScreen:(GLKVector2)translation {
    GLKVector3 endPoint = _eye;

    [self pickupPointAtScreen:translation farPlanePoint:&endPoint];
    return GLKVector3Subtract(endPoint, _originFarPoint);
}

- (void)updateCamera {
    if(!_dirty) {
        return;
    }
    
    _viewMatrix = GLKMatrix4MakeLookAt(_eye.x, _eye.y, _eye.z,
                                           _lookAt.x, _lookAt.y, _lookAt.z,
                                           0.0f, 1.0f, 0.0f);
    [self pickupPointAtScreen:GLKVector2Make(0.0f, 0.0f) farPlanePoint:&_originFarPoint];
    
    _dirty = NO;
}

- (void)setEye:(GLKVector3)eye {
    eye = _eye;
    _dirty = YES;
}

- (void)setLookAt:(GLKVector3)lookAt {
    lookAt = _lookAt;
    _dirty = YES;
}

- (void)initCamera:(GLKVector3)eye lookAt:(GLKVector3)lookAt {
    _eye = eye;
    _lookAt = lookAt;
    _dirty = YES;
    
    [self initProjection];
}

- (void)initProjection {
    UIScreenMode *screenMode = [[UIScreen mainScreen] currentMode];
    float screenWidth = screenMode.size.width;
    float screenHeight = screenMode.size.height;
    
    glViewport(0, 0, screenWidth, screenHeight);
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60.0f), screenWidth/screenHeight, 0.1f, 100.0f);
    
    _viewport[0] = 0;
    _viewport[1] = 0;
    _viewport[2] = screenMode.size.width;
    _viewport[3] = screenMode.size.height;
}

@end
