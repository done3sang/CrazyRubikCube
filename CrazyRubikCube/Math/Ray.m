//
//  Ray.m
//  CrazyRubikCube
//
//  Created by xy on 07/02/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "Ray.h"

@implementation Ray

@synthesize origin = _origin;
@synthesize direction = _direction;

- (instancetype)initWithRay:(GLKVector3)origin direction:(GLKVector3)direction {
    if(self == [super init]) {
        _origin = origin;
        _direction = direction;
    }
    
    return self;
}

+ (Ray*)rayWithRay:(GLKVector3)origin direction:(GLKVector3)direction {
    return [[Ray alloc] initWithRay:origin direction:direction];
}

- (GLKVector3)pointAtLength:(float)t {
    return GLKVector3Add(_origin, GLKVector3MultiplyScalar(_direction, t));
}

@end
