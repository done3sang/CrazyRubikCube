//
//  MathUtil.m
//  CrazyRubikCube
//
//  Created by Sang on 1/2/17.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "MathUtil.h"

const float kPi         = 3.14159265f;
const float k2Pi        = 2.0f * kPi;
const float kPiOver2    = kPi / 2.0f;
const float k1OverPi    = 1.0f / kPi;
const float k1Over2Pi   = 1.0f / k2Pi;

const float kEpsilon    = 0.0001f;

@implementation MathUtil

+ (float)wrapPi:(float)theta {
    theta += kPi;
    theta -= floorf(theta * k1Over2Pi)* k2Pi;
    theta -= kPi;
    
    return theta;
}

+ (float)safeAsin:(float)value {
    float radian = 0.0f;
    
    if(value <= -1.0f) {
        radian = -kPiOver2;
    } else if(value >= 1.0f) {
        radian = kPiOver2;
    } else {
        radian = asinf(value);
    }
    
    return radian;
}

+ (float)safeAcos:(float)value {
    float radian = 0.0f;
    
    if(value <= -1.0f) {
        radian = kPi;
    } else if(value >= 1.0f) {
        radian = 0.0f;
    } else {
        radian = acosf(value);
    }
    
    return radian;
}

+ (float)fade:(float)t {
    return t * t * t * (t * (t * 6.0f - 15.0f) + 10.0f);
}

+(float)lerp:(float)t begin:(float)a end:(float)b {
    return a + t * (b - a);
}

+ (int)clamp:(int)t begin:(int)a end:(int)b {
    return t < a ? a : (t > b ? b: t);
}

+ (float)fract:(float)value {
    return value - (float)((int)value);
}

+ (BOOL)interval:(float)value beginValue:(float)beg endValue:(float)ev {
    return beg <= value && value <= ev;
}
@end
