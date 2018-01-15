//
//  SphereBoundingVolume.h
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class BoundingVolume;

@interface SphereBoundingVolume : BoundingVolume {
    GLKVector3 _center;
    float _radius;
}

@property (nonatomic, readonly) GLKVector3 center;
@property (nonatomic, readonly) float radius;

- (instancetype)initWithSphere:(GLKVector3)center radius:(float)radius;

+ (SphereBoundingVolume*)sphereWithSphere:(GLKVector3)center radius:(float)radius;

@end
