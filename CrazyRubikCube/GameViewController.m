//
//  GameViewController.m
//  CrazyRubikCube
//
//  Created Sang xy on 05/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <OpenGLES/ES2/glext.h>
#import "GameViewController.h"
#import "Director.h"
#import "OpenGLMaker.h"
#import "SceneNode.h"
#import "Scene.h"
#import "RubikScene.h"
#import "MathUtil.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface GameViewController () {
    Director *_sharedDirector;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sharedDirector = [Director sharedDirector];
    
    GLKView *view = (GLKView *)self.view;
    view.context = _sharedDirector.openGLMaker.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.multipleTouchEnabled = YES;
    view.userInteractionEnabled = YES;
    
    [self gameRun];
    
    float backlighLevel = [UIScreen mainScreen].brightness;
    NSLog(@"Screen light level = %f", backlighLevel);
    //[UIScreen mainScreen].brightness = 1.0f;
    
    [self addGestures];
}

- (void)gameRun {
    [_sharedDirector runScene:(Scene*)[RubikScene rubikScene]];
}

#pragma mark - gestures
- (void)addGestures {
    // tap
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRubik:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    //long press
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRubik:)];
    longPressGesture.minimumPressDuration = 0.5f;
    [self.view addGestureRecognizer:longPressGesture];
    
    // pinch
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRubik:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    // rotation
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationRubik:)];
    [self.view addGestureRecognizer:rotationGesture];
    
    //pan
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRubik:)];
    [self.view addGestureRecognizer:panGesture];
    
    //swipe
    //swipe horizontal
    UISwipeGestureRecognizer *swipeGestureToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRubik:)];
    swipeGestureToRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureToRight];
    
    UISwipeGestureRecognizer *swipeGestureToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRubik:)];
    swipeGestureToRight.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureToLeft];
    
    //swipe vertical
    UISwipeGestureRecognizer *swipeGestureToUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRubik:)];
    swipeGestureToRight.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureToUp];
    
    UISwipeGestureRecognizer *swipeGestureToDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRubik:)];
    swipeGestureToRight.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureToDown];
    
    //conflict
    [swipeGestureToRight requireGestureRecognizerToFail:panGesture];
    [swipeGestureToLeft requireGestureRecognizerToFail:panGesture];
    [swipeGestureToUp requireGestureRecognizerToFail:panGesture];
    [swipeGestureToDown requireGestureRecognizerToFail:panGesture];
    
    [longPressGesture requireGestureRecognizerToFail:panGesture];
    
    //[panGesture requireGestureRecognizerToFail:rotationGesture];
    [pinchGesture requireGestureRecognizerToFail:rotationGesture];
}

- (void)tapRubik:(UITapGestureRecognizer*)gesture {
    NSLog(@"tapRubik: %li", (long)gesture.state);
    [_sharedDirector tapGesture:gesture];
}

- (void)longPressRubik:(UILongPressGestureRecognizer*)gesture {
    NSLog(@"longpress: %li", gesture.state);
    [_sharedDirector longPressGesture:gesture];
}

- (void)pinchRubik:(UIPinchGestureRecognizer*)gesture {
    NSLog(@"pinchRubik: %li", gesture.state);
    [_sharedDirector pinchGesture:gesture];
}

- (void)rotationRubik:(UIRotationGestureRecognizer*)gesture {
    NSLog(@"rotationRubik: %li", gesture.state);
    [_sharedDirector rotationGesture:gesture];
}

- (void)panRubik:(UIPanGestureRecognizer*)gesture {
    NSLog(@"panRubik: %li", gesture.state);
    [_sharedDirector panGesture:gesture];
}

- (void)swipeRubik:(UISwipeGestureRecognizer*)gesture {
    NSLog(@"swipeRubik: %li, direction: %li", gesture.state, gesture.direction);
    [_sharedDirector swipeGesture:gesture];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    [_sharedDirector update:self.timeSinceLastUpdate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [_sharedDirector render];
}

- (void)logTouchInfo:(UITouch*)touch {
    NSLog(@"    touch.hash = %ld", (long)touch.hash);
    NSLog(@"    touch.phase = %ld", (long)touch.phase);
    NSLog(@"    touch.tapCount = %lu", (unsigned long)touch.tapCount);
}

- (void)logTochesInfo:(NSSet<UITouch*>*)touches {
    for (UITouch *touch in touches) {
        [self logTouchInfo:touch];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"\n\ntouchesBegan - touch count = %lu", (unsigned long)[touches count]);
    //[self logTochesInfo:touches];
    [_sharedDirector touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"\n\ntouchesMoved - touch count = %lu", (unsigned long)[touches count]);
    //[self logTochesInfo:touches];
    [_sharedDirector touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"\n\ntouchesEnded - touch count = %lu", (unsigned long)[touches count]);
    //[self logTochesInfo:touches];
    [_sharedDirector touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"\n\ntouchesCancelled - touch count = %lu", (unsigned long)[touches count]);
    //[self logTochesInfo:touches];
    [_sharedDirector touchesCancelled:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
}

@end
