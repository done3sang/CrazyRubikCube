//
//  Profile.m
//  CrazyRubikCube
//
//  Created by xy on 10/07/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Profile.h"
#import "ProfileSample.h"
#import "ProfileSampleHistory.h"

static Profile *_sharedProfile = nil;

@implementation Profile

+ (Profile*)sharedProfile {
    if(nil == _sharedProfile) {
        _sharedProfile = [[Profile alloc] initWithSize:32];
    }
    
    return _sharedProfile;
}

- (instancetype)initWithSize:(size_t)sampleSize {
    if(self = [super init]) {
        _sampleArr = [NSMutableArray arrayWithCapacity:sampleSize];
        _sampleHistoryDict = [NSMutableDictionary dictionaryWithCapacity:sampleSize];
        
        [self initProfile];
    }
    
    return self;
}

- (void)beginSample:(NSString *)sampleName {
    ProfileSample *sample = [self sampleByName:sampleName];
    
    NSAssert1(!sample.valid, @"\nERROR: Profile.beginProfile(%@), sample can open only once at one time", sampleName);
    
    sample.openedCount = 1;
    ++sample.sampleInstances;
    sample.startTime = CACurrentMediaTime();
    sample.valid = YES;
}

- (void)endSample:(NSString *)sampleName {
    ProfileSample *tsample = [self sampleByName:sampleName];
    
    NSAssert1(tsample.valid, @"\nERROR: Profile.endProfile(%@), cannot find relative sample", sampleName);
    NSAssert1(1 == tsample.openedCount, @"\nERROR: Profile.endProfile(%@), sample can close only once at one time", sampleName);
    
    double sampleTime = CACurrentMediaTime() - tsample.startTime;
    
    tsample.openedCount = 0;
    tsample.accumulatedTime += sampleTime;
    tsample.valid = NO;
    
    ProfileSample *parentSample = nil;
    size_t parentCount = 0;
    
    for (ProfileSample *sample in _sampleArr) {
        if([sample.name isEqualToString:sampleName]) {
            if(parentSample) {
                parentSample.childrenSampleTime += sampleTime;
            }
            
            tsample.parentCount = parentCount;
            return;
        } else {
            if(sample.valid) {
                // no intersection
                NSAssert1(1 == sample.openedCount,
                          @"\nERROR: Profile.endProfile(%@), sample only one", sample.name);
                
                parentSample = sample;
                
                ++parentCount;
            }
        }
    }
    
    NSAssert1(NO, @"\nERROR: Profile.endProfile(%@), cannot find", sampleName);
}

- (void)startProfile {
    [self clearProfile];
    
    _profileTime = CACurrentMediaTime();
    [self beginSample:_mainSampleName];
}

- (void)finishProfile {
    [self endSample:_mainSampleName];
    _profileTime = CACurrentMediaTime() - _profileTime;
    
    for (ProfileSample *sample in _sampleArr) {
        NSAssert2(!sample.valid && 0 == sample.openedCount,
                  @"ERROR: Profile.finishProfile, sample(%@) not finished: %zu", sample.name, sample.openedCount);
        
        [self storeProfileInHistory:sample];
    }
}

- (NSString*)dumpProfile {
    //ProfileSampleHistory *mainSampleHistory = [_sampleHistoryDict objectForKey:_mainSampleName];
    
    [_profileDesc setString:@"Average   |   Min     |   Max     |   #   |   Profile Name\n"];
    [_profileDesc appendString:@"--------------------------------------------------------------\n"];
    
    NSString *historyDesc = nil;
    NSString *nameDesc = nil;
    
    for (NSString *sampleKey in _sampleHistoryDict) {
        ProfileSampleHistory *sampleHistory = [_sampleHistoryDict objectForKey:sampleKey];
        
        nameDesc = sampleHistory.sampleName;
        for(size_t i = 0; i < sampleHistory.sampleTabs; ++i) {
            nameDesc = [NSString stringWithFormat:@" %@", nameDesc];
        }
        
        historyDesc = [NSString stringWithFormat:@"%05.2f     |   %05.2f   |   %05.2f   |   %03zu |   %@\n",
                       sampleHistory.averageTime, sampleHistory.minTime, sampleHistory.maxTime,
                       sampleHistory.sampleInstances,
                       nameDesc];
        [_profileDesc appendString:historyDesc];
    }
    
    return _profileDesc;
}

- (void)storeProfileInHistory:(ProfileSample*)sample {
    ProfileSampleHistory *sampleHistory = [_sampleHistoryDict objectForKey:sample.name];
    
    double percentTime = (sample.accumulatedTime - sample.childrenSampleTime)/_profileTime * 100.0;
    
    if(nil == sampleHistory) {
        sampleHistory = [ProfileSampleHistory historyWithName:sample.name];
        [_sampleHistoryDict setObject:sampleHistory forKey:sample.name];
        
        sampleHistory.averageTime = percentTime;
        sampleHistory.minTime = percentTime;
        sampleHistory.maxTime = percentTime;
    } else {
        double newRatio = 0.8 * _profileTime;
        
        newRatio = newRatio > 1.0 ? 1.0: newRatio;
        double oldRatio = 1.0 - newRatio;
        double newRatioPercent = percentTime * newRatio;
        
        sampleHistory.averageTime = sampleHistory.averageTime * oldRatio + newRatioPercent;
        
        if(percentTime < sampleHistory.minTime) {
            sampleHistory.minTime = percentTime;
        } else {
            sampleHistory.minTime = sampleHistory.minTime * oldRatio + newRatioPercent;
        }
        
        if(sampleHistory.maxTime < percentTime) {
            sampleHistory.maxTime = percentTime;
        } else {
            sampleHistory.maxTime = sampleHistory.maxTime * oldRatio + newRatioPercent;
        }
    }
    
    sampleHistory.sampleTabs = sample.parentCount;
    sampleHistory.sampleInstances = sample.sampleInstances;
}

- (ProfileSample*)sampleByName:(NSString*)sampleName {
    ProfileSample *firstInvalidSample = nil;
    
    for (ProfileSample *sample in _sampleArr) {
        if([sample.name isEqualToString:sampleName]) {
            return sample;
        }
        
        if(nil == firstInvalidSample && !sample.valid) {
            firstInvalidSample = sample;
        }
    }
    
    if(nil == firstInvalidSample) {
        firstInvalidSample = [ProfileSample sampleWithName:sampleName];
        [_sampleArr addObject:firstInvalidSample];
    }
    
    return firstInvalidSample;
}

- (void)initProfile {
    for(NSUInteger i = 0; i < _sampleArr.count; ++i) {
        NSString *sampleName = [NSString stringWithFormat:@"ProfileSample_%zu", i];
        
        [_sampleArr setObject:[ProfileSample sampleWithName:sampleName] atIndexedSubscript:i];
    }
    
    _profileDesc = [NSMutableString stringWithCapacity:1024];
    _mainSampleName = @"Main Loop";
}

- (void)clearProfile {
    for (ProfileSample *sample in _sampleArr) {
        [sample clearSample];
    }
}

@end
