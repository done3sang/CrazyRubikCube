//
//  OpenGLViewController.h
//  CrazyRubikCube
//
//  Created by xy on 12/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface OpenGLViewController : UIViewController<OpenGLViewDelegate>

@property (nonatomic) int preferredFramesPerSecond;

@property (nonatomic, readonly) int framesPerSecond;

@property (nonatomic, getter=isPaused) BOOL paused;

@end
