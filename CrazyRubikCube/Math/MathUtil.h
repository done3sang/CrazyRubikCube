//
//  MathUtil.h
//  CrazyRubikCube
//
//  Created by Sang on 1/2/17.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const float kPi;
extern const float k2Pi;
extern const float kPiOver2;
extern const float k1OverPi;
extern const float k1Over2Pi;

extern const float kEpsilon;

@interface MathUtil : NSObject

+ (float)wrapPi:(float)theta;

+ (float)safeAsin:(float)value;

+ (float)safeAcos:(float)value;

+ (float)fade:(float)t;

+ (float)lerp:(float)t begin:(float)a end:(float)b;

+ (int)clamp:(int)t begin:(int)a end:(int)b;

+ (float)fract:(float)value;

+ (BOOL)interval:(float)value beginValue:(float)beg endValue:(float)ev;

@end
