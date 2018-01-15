//
//  Profile.h
//  CrazyRubikCube
//
//  Created by xy on 10/07/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject {
    NSMutableArray *_sampleArr;
    NSMutableDictionary *_sampleHistoryDict;
    
    double _profileTime;
    NSMutableString *_profileDesc;
    NSString *_mainSampleName;
}

+ (nonnull Profile*)sharedProfile;

- (void)beginSample:(nonnull NSString*)sampleName;

- (void)endSample:(nonnull NSString*)sampleName;

- (void)startProfile;

- (void)finishProfile;

- (nonnull NSString*)dumpProfile;

@end
