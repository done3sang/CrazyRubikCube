//
//  ProfileSample.h
//  CrazyRubikCube
//
//  Created by xy on 10/07/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileSample : NSObject {
    NSString *_name;
    BOOL _valid;
    size_t _openedCount;
    size_t _sampleInstances;
    double _startTime;
    double _accumulatedTime;
    double _childrenSampleTime;
    size_t _parentCount;
}

@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, assign) size_t openedCount;
@property (nonatomic, assign) size_t sampleInstances;
@property (nonatomic, assign) double startTime;
@property (nonatomic, assign) double accumulatedTime;
@property (nonatomic, assign) double childrenSampleTime;
@property (nonatomic, assign) size_t parentCount;

- (nonnull instancetype)initWithName:(nonnull NSString*)name;

+ (nonnull ProfileSample*)sampleWithName:(nonnull NSString*)name;

- (void)clearSample;

@end
