//
//  OpenGLViewController.m
//  CrazyRubikCube
//
//  Created by xy on 12/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OpenGLViewController.h"

@interface OpenGLViewController () {
    CADisplayLink *_renderLink;
    int _preferredFramesPerSecond;
}

@end

@implementation OpenGLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _renderLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
        
        self.preferredFramesPerSecond = 30;
        
        [_renderLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        self.paused = NO;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        _renderLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
        
        self.preferredFramesPerSecond = 30;
        
        [_renderLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        self.paused = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    OpenGLView *view = (OpenGLView*)self.view;
    
    NSAssert([view isKindOfClass:[OpenGLView class]],
             @"OpenGL View Controller's view is not a OpenGLView");
    
    view.opaque = YES;
    view.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.paused = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.paused = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    
    return YES;
}

- (void)drawView {
    [(OpenGLView*)self.view render];
}

- (int)framesPerSecond {
    return 60/_renderLink.frameInterval;
}

- (int)preferredFramesPerSecond {
    return _preferredFramesPerSecond;
}

- (void)setPreferredFramesPerSecond:(int)aValue {
    _preferredFramesPerSecond = aValue;
    _renderLink.frameInterval = MAX(1, (60/aValue));
}

- (BOOL)isPaused {
    return _renderLink.paused;
}

- (void)setPaused:(BOOL)paused {
    _renderLink.paused = paused;
}

- (void)renderView:(OpenGLView *)glView renderInRect:(CGRect)renderRect {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
