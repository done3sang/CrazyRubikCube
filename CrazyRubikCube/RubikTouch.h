//
//  RubikTouch.h
//  CrazyRubikCube
//
//  Created by xy on 20/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "RubikTypes.h"

@interface RubikTouch : NSObject {
    NSUInteger _touchID;
    UITouch *_touch;
    
    GLKVector3 _intersection;
    BOOL _joint;
    
    id _touchedBlock;
}

@property (nonatomic, readonly) NSUInteger touchID;
@property (nonatomic, strong, nullable) UITouch *touch;
@property (nonatomic, assign) GLKVector3 intersection;
@property (nonatomic, assign) BOOL joint;
@property (nonatomic, strong, nullable) id touchedBlock;

- (nonnull instancetype)initWithTouch:(nonnull UITouch*)touch
                         intersection:(GLKVector3)intersection;

+ (nonnull RubikTouch*)rubikTouchWithTouch:(nonnull UITouch*)touch
                              intersection:(GLKVector3)intersection;

+ (nonnull RubikTouch*)touch;

- (BOOL)isEqualToUITouch:(nullable UITouch*)touch;

@end
