//
//  OrientedBoundingBox.m
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "OrientedBoundingBox.h"

@implementation OrientedBoundingBox

@synthesize center = _center;
@synthesize extent = _extent;

- (instancetype)initWithOBB:(GLKVector3)center axes:(GLKVector3*)axes extent:(GLKVector3)extent {
    if(self = [super init]) {
        _center = center;
        _axes[0] = axes[0];
        _axes[1] = axes[1];
        _axes[2] = axes[2];
        _extent = extent;
    }
    
    return self;
}

+ (OrientedBoundingBox*)OBBWithOBB:(GLKVector3)center axes:(GLKVector3*)axes extent:(GLKVector3)extent {
    return [[OrientedBoundingBox alloc] initWithOBB:center axes:axes extent:extent];
}

- (GLKVector3*)axes {
    return _axes;
}

@end
