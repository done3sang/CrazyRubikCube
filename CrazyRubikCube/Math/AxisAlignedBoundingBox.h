//
//  AxisAlignedBoundingBox.h
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class BoundingVolume;

@interface AxisAlignedBoundingBox : BoundingVolume {
    GLKVector3 _min;
    GLKVector3 _max;
}

@property (nonatomic, readonly) GLKVector3 min;
@property (nonatomic, readonly) GLKVector3 max;

- (instancetype)initWithAABB:(GLKVector3)min maxPoint:(GLKVector3)max;

+ (AxisAlignedBoundingBox*)AABBWithAABB:(GLKVector3)min maxPoint:(GLKVector3)max;

@end
