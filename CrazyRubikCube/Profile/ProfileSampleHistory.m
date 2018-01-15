//
//  ProfileSampleHistory.m
//  CrazyRubikCube
//
//  Created by xy on 10/07/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "ProfileSample.h"
#import "ProfileSampleHistory.h"

@implementation ProfileSampleHistory

@synthesize sampleName = _sampleName;
@synthesize averageTime = _averageTime;
@synthesize minTime = _minTime;
@synthesize maxTime = _maxTime;
@synthesize sampleTabs = _sampleTabs;
@synthesize sampleInstances = _sampleInstances;

- (instancetype)initWithName:(NSString *)sampleName {
    if(self = [super init]) {
        _sampleName = sampleName;
        _averageTime = 0.0f;
        _minTime = 0.0f;
        _maxTime = 0.0f;
        _sampleTabs = 0;
        _sampleInstances = 0;
    }
    
    return self;
}

+ (ProfileSampleHistory*)historyWithName:(NSString *)sampleName {
    return [[ProfileSampleHistory alloc] initWithName:sampleName];
}

- (void)updateWithSample:(ProfileSample *)sample {
    NSAssert([_sampleName isEqualToString:sample.name], @"ERROR: ProfileSampleHistory.updateWithSample, sample not matched");
    
    
}
@end
