//
//  OrientedBoundingBox.h
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface OrientedBoundingBox : NSObject {
    GLKVector3 _center;
    GLKVector3 _axes[3];
    GLKVector3 _extent;
}

@property (nonatomic, readonly) GLKVector3 center;
@property (nonatomic, readonly) GLKVector3 *axes;
@property (nonatomic, readonly) GLKVector3 extent;

- (instancetype)initWithOBB:(GLKVector3)center axes:(GLKVector3*)axes extent:(GLKVector3)extent;

+ (OrientedBoundingBox*)OBBWithOBB:(GLKVector3)center axes:(GLKVector3*)axes extent:(GLKVector3)extent;

@end
