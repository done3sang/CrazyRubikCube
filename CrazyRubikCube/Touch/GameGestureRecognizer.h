//
//  TouchBase.h
//  CrazyRubikCube
//
//  Created by xy on 26/10/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class SceneNode;

typedef NS_ENUM(NSInteger, GameGestureRecognizerState) {
    GameGestureRecognizerStatePossible,
    UGameGestureRecognizerStateBegan,
    GameGestureRecognizerStateChanged,
    GameGestureRecognizerStateEnded,
    GameGestureRecognizerStateCancelled,
    UGameGestureRecognizerStateFailed,
    GameGestureRecognizerStateRecognized = GameGestureRecognizerStateEnded
};

@interface GameGestureRecognizer : NSObject

@property (nonatomic, nonnull, readonly) NSString *name;

@property (nonatomic, readonly) GameGestureRecognizerState state;

@property (nonatomic, getter=isEnabled) BOOL enabled;

@property (nonatomic, nullable, readonly) SceneNode *target;

- (nonnull instancetype)initWithTarget:(nullable SceneNode*)target action:(nullable SEL)action;

- (void)updateTarget:(nullable SceneNode*)target action:(nullable SEL)action;

- (void)clearTarget;

- (GLKVector2)locationInViewport;

- (GLKVector3)locationInTarget;

@end
