//
//  ProfileSampleHistory.h
//  CrazyRubikCube
//
//  Created by xy on 10/07/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileSample;

@interface ProfileSampleHistory : NSObject {
    NSString *_sampleName;
    size_t _sampleTabs;
    size_t _sampleInstances;
    
    float _averageTime;
    float _minTime;
    float _maxTime;
}

@property (nonatomic, nonnull) NSString *sampleName;
@property (nonatomic, assign) float averageTime;
@property (nonatomic, assign) float minTime;
@property (nonatomic, assign) float maxTime;
@property (nonatomic, assign) size_t sampleTabs;
@property (nonatomic, assign) size_t sampleInstances;

- (nonnull instancetype)initWithName:(nonnull NSString*)sampleName;

+ (nonnull ProfileSampleHistory*)historyWithName:(nonnull NSString*)sampleName;

- (void)updateWithSample:(nonnull ProfileSample*)sample;

@end
