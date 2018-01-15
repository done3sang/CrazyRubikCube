//
//  AxisAlignedBoundingBox.m
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "BoundingVolume.h"
#import "AxisAlignedBoundingBox.h"

@implementation AxisAlignedBoundingBox

@synthesize min = _min;
@synthesize max = _max;

- (instancetype)initWithAABB:(GLKVector3)min maxPoint:(GLKVector3)max {
    if(self = [super init]) {
        _min = min;
        _max = max;
    }
    
    return self;
}

+ (AxisAlignedBoundingBox*)AABBWithAABB:(GLKVector3)min maxPoint:(GLKVector3)max {
    return [[AxisAlignedBoundingBox alloc] initWithAABB:min maxPoint:max];
}

- (NSString*)className {
    return @"AxisAlignedBoundingBox";
}

@end
