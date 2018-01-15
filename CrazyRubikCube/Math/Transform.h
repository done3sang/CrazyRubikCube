//
//  Transform.h
//  CrazyRubikCube
//
//  Created by xy on 09/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class EulerAngle;

@interface Transform : NSObject<NSCopying> {
    GLKVector3 _position;
    GLKVector3 _scale;
    EulerAngle *_eulerAngle;
    
    BOOL _dirty;
    
    GLKMatrix4 _local2WorldMatrix;
    GLKMatrix4 _world2LocalMatrix;
    
    GLKMatrix4 _extraMatrix;
    
    GLKMatrix4 _modelMatrix;
}

@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic, assign) GLKVector3 scale;

@property (nonatomic, assign) float xRotation;
@property (nonatomic, assign) float yRotation;
@property (nonatomic, assign) float zRotation;

@property (nonatomic, strong, nonnull) EulerAngle *eulerAngle;

@property (nonatomic, readonly) GLKMatrix4 local2WorldMatrix;
@property (nonatomic, readonly) GLKMatrix4 world2LocalMatrix;

@property (nonatomic, assign) GLKMatrix4 extraMatrix;

@property (nonatomic, readonly) GLKMatrix4 modelMatrix;

- (nonnull instancetype)init;

- (nonnull instancetype)initWithPosition:(GLKVector3)position;

+ (nonnull Transform*)transformWithIdentity;

+ (nonnull Transform*)transformWithPosition:(GLKVector3)position;

- (void)identity;

- (void)translate:(GLKVector3)offset;

- (GLKVector3)local2WorldPoint:(GLKVector3)point;

- (GLKVector3)local2WorldDirection:(GLKVector3)direction;

- (GLKVector3)world2LocalPoint:(GLKVector3)point;

- (GLKVector3)world2LocalDirection:(GLKVector3)direction;

- (void)transformWithMatrix:(GLKMatrix4)mat; // a total matrix from local to world to local

- (nonnull id)copyWithZone:(nullable NSZone *)zone;

@end
