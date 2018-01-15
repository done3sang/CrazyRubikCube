//
//  Director.m
//  CrazyRubikCube
//
//  Created by xy on 20/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "Camera.h"
#import "SceneNode.h"
#import "Scene.h"
#import "OpenGLMaker.h"
#import "Director.h"
#import "Profile.h"

static Director *s_sharedDirector = nil;

@implementation Director

@synthesize mainCamera = _mainCamera;
@synthesize runningScene = _runningScene;
@synthesize openGLMaker = _openGLMaker;
@synthesize frameElapsedTime = _frameElapsedTime;

- (instancetype)init {
    if(self = [super init]) {
        _openGLMaker = [OpenGLMaker sharedOpenGLMaker];
        _mainCamera = [Camera mainCamera];
        _runningScene = nil;
        
        // for profile
#ifdef DEBUG
        _gameProfile = [Profile sharedProfile];
#endif
    }
    
    return self;
}

+ (Director*)sharedDirector {
    if(nil == s_sharedDirector) {
        s_sharedDirector = [[Director alloc] init];
    }
    
    return s_sharedDirector;
}

- (void)update:(float)deltaTime {
    _frameElapsedTime = deltaTime;
    [_mainCamera update:deltaTime];
    
    if(_runningScene) {
        [_runningScene update:deltaTime];
    }
    
#ifdef DEBUG
    [_gameProfile finishProfile];
    
    //NSLog(@"\n%@\n", [_gameProfile dumpProfile]);
#endif
}

- (void)render {
#ifdef DEBUG
    [_gameProfile startProfile];
    [_gameProfile beginSample:@"Graphic Render"];
#endif
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if(_runningScene) {
        [_runningScene render:GLKMatrix4Identity];
    }
    
#ifdef DEBUG
    [_gameProfile endSample:@"Graphic Render"];
#endif
}

- (void)runScene:(Scene *)newScene {
    _runningScene = newScene;
}

#pragma mark handle touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(_runningScene) {
        [_runningScene touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(_runningScene) {
        [_runningScene touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(_runningScene) {
        [_runningScene touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(_runningScene) {
        [_runningScene touchesCancelled:touches withEvent:event];
    }
}

#pragma mark handle gestures

- (void)tapGesture:(nonnull UITapGestureRecognizer*)gesture {
    if(_runningScene) {
        [_runningScene tapGesture:gesture];
    }
}

- (void)longPressGesture:(nonnull UILongPressGestureRecognizer*)gesture {
    if(_runningScene) {
        [_runningScene longPressGesture:gesture];
    }
}

- (void)pinchGesture:(UIPinchGestureRecognizer*)gesture {
    if(_runningScene) {
        [_runningScene pinchGesture:gesture];
    }
}

- (void)rotationGesture:(UIRotationGestureRecognizer*)gesture {
    if(_runningScene) {
        [_runningScene rotationGesture:gesture];
    }
}

- (void)panGesture:(nonnull UIPanGestureRecognizer*)gesture {
    if(_runningScene) {
        [_runningScene panGesture:gesture];
    }
}

- (void)swipeGesture:(nonnull UISwipeGestureRecognizer*)gesture {
    if(_runningScene) {
        [_runningScene swipeGesture:gesture];
    }
}

@end
