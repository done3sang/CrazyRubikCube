//
//  ProfileSample.m
//  CrazyRubikCube
//
//  Created by xy on 10/07/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "ProfileSample.h"

@implementation ProfileSample

@synthesize name = _name;
@synthesize openedCount = _openedCount;
@synthesize sampleInstances = _sampleInstances;
@synthesize startTime = _startTime;
@synthesize accumulatedTime = _accumulatedTime;
@synthesize childrenSampleTime = _childrenSampleTime;
@synthesize parentCount = _parentCount;

- (instancetype)initWithName:(NSString *)name {
    if(self = [super init]) {
        _name = name;
        [self clearSample];
    }
    
    return self;
}

+ (ProfileSample*)sampleWithName:(NSString *)name {
    return [[ProfileSample alloc] initWithName:name];
}

- (void)clearSample {
    _valid = NO;
    _openedCount = 0;
    _sampleInstances = 0;
    _startTime = 0.0;
    _accumulatedTime = 0.0;
    _childrenSampleTime = 0.0;
    _parentCount = 0;
}

@end
