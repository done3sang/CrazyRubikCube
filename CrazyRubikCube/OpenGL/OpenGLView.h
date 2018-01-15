//
//  OpenGLView.h
//  CrazyRubikCube
//
//  Created by xy on 09/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@protocol OpenGLViewDelegate;

@interface OpenGLView : UIView {
    EAGLContext *_glContext;
    GLuint      _defaultFramebuffer;
    GLuint      _colorRenderbuffer;
    GLuint      _depthRenderbuffer;
}

@property (nonatomic, weak) IBOutlet id<OpenGLViewDelegate> delegate;

@property (nonatomic, strong) EAGLContext* context;

@property (nonatomic, readonly) GLint drawableWidth;

@property (nonatomic, readonly) GLint drawableHeight;

- (void)render;

@end

#pragma mark - OpenGLViewDelegate

@protocol OpenGLViewDelegate<NSObject>

@required
- (void)renderView:(OpenGLView*)glView renderInRect:(CGRect)renderRect;

@end
