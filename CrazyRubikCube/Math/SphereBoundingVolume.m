//
//  SphereBoundingVolume.m
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "BoundingVolume.h"
#import "SphereBoundingVolume.h"

@implementation SphereBoundingVolume

@synthesize center = _center;
@synthesize radius = _radius;

- (instancetype)initWithSphere:(GLKVector3)center radius:(float)radius {
    if(self = [super init]) {
        _center = center;
        _radius = radius;
    }
    
    return self;
}

+ (SphereBoundingVolume*)sphereWithSphere:(GLKVector3)center radius:(float)radius {
    return [[SphereBoundingVolume alloc] initWithSphere:center radius:radius];
}

- (NSString*)className {
    return @"SphereBoundingVolume";
}

@end
