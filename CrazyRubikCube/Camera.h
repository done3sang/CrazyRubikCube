//
//  Camera.h
//  CrazyRubikCube
//
//  Created by xy on 06/02/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Ray;

@interface Camera : NSObject {
    GLKVector3 _eye;
    GLKVector3 _lookAt;
    
    BOOL _dirty;
    GLKMatrix4 _viewMatrix;
    GLKMatrix4 _projectionMatrix;
    GLKVector3 _originFarPoint;
    
    int _viewport[4];
}

@property (nonatomic, assign) GLKVector3 eye;
@property (nonatomic, assign) GLKVector3 lookAt;
@property (nonatomic, readonly) GLKMatrix4 viewMatrix;
@property (nonatomic, readonly) GLKMatrix4 projectionMatrix;
@property (nonatomic, readonly) GLKMatrix4 viewProjectionMatrix;

+ (Camera*)mainCamera;

- (instancetype)init;

- (instancetype)initWithView:(GLKVector3)eye lookAt:(GLKVector3)lookAt;

- (void)update:(float)deltaTime;

- (void)render;

- (Ray*)pickupRayAtScreen:(GLKVector2)screenPoint;

- (GLKVector3)pickupDirectionAtScreen:(GLKVector2)translation;

@end
