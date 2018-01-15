//
//  Director.h
//  CrazyRubikCube
//
//  Created by xy on 20/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Camera;
@class Scene;
@class OpenGLMaker;
@class Profile;

@interface Director : NSObject {
    Camera *_mainCamera;
    Scene *_runningScene;
    OpenGLMaker *_openGLMaker;
    float _frameElapsedTime;
    
    //for profile
#ifdef DEBUG
    Profile *_gameProfile;
#endif
}

@property (nonatomic, strong, nonnull) Camera *mainCamera;
@property (nonatomic, strong, nullable) Scene *runningScene;
@property (nonatomic, strong, nonnull) OpenGLMaker *openGLMaker;
@property (nonatomic, readonly) float frameElapsedTime;

- (nonnull instancetype)init;

+ (nonnull Director*)sharedDirector;

- (void)update:(float)deltaTime;

- (void)render;

- (void)runScene:(nullable Scene*)newScene;

# pragma mark handle touches

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nonnull UIEvent *)event;

- (void)touchesMoved:(nonnull NSSet<UITouch *> *)touches withEvent:(nonnull UIEvent *)event;

- (void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nonnull UIEvent *)event;

- (void)touchesCancelled:(nonnull NSSet<UITouch *> *)touches withEvent:(nonnull UIEvent *)event;

#pragma mark gesture

- (void)tapGesture:(nonnull UITapGestureRecognizer*)gesture;

- (void)longPressGesture:(nonnull UILongPressGestureRecognizer*)gesture;

- (void)pinchGesture:(nonnull UIPinchGestureRecognizer*)gesture;

- (void)rotationGesture:(nonnull UIRotationGestureRecognizer*)gesture;

- (void)panGesture:(nonnull UIPanGestureRecognizer*)gesture;

- (void)swipeGesture:(nonnull UISwipeGestureRecognizer*)gesture;

@end
