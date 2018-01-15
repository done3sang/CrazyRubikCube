//
//  RubikTouch.m
//  CrazyRubikCube
//
//  Created by xy on 20/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "RubikTouch.h"

@implementation RubikTouch

@synthesize touchID = _touchID;
@synthesize touch = _touch;
@synthesize intersection = _intersection;
@synthesize joint = _joint;
@synthesize touchedBlock = _touchedBlock;

- (instancetype)initWithTouch:(nonnull UITouch*)touch
                 intersection:(GLKVector3)intersection {
    if(self = [super init]) {
        _touchID = touch.hash;
        _touch = touch;
        _intersection = intersection;
    }
    
    return self;
}

+ (RubikTouch*)rubikTouchWithTouch:(nonnull UITouch*)touch
                      intersection:(GLKVector3)intersection {
    return [[RubikTouch alloc] initWithTouch:touch
                                intersection:intersection];
}

+ (RubikTouch*)touch {
    RubikTouch *touch = [[RubikTouch alloc] init];
    [touch clearTouch];
    
    return touch;
}

- (BOOL)isEqualToUITouch:(UITouch *)touch {
    return nil != touch && _touchID == touch.hash;
}

- (void)clearTouch {
    _touchID = 0;
    _touch = nil;
    _touchedBlock = nil;
    _intersection = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _joint = NO;
}

@end
