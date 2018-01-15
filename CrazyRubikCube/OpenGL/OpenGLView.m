//
//  OpenGLView.m
//  CrazyRubikCube
//
//  Created by xy on 09/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import "OpenGLView.h"

@implementation OpenGLView

@synthesize delegate;
@synthesize drawableWidth;
@synthesize drawableHeight;

@synthesize context = _glContext;

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame context:(EAGLContext*)aContext {
    if(self = [super initWithFrame:frame]) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*)self.layer;
        
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:NO],
                                        kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyColorFormat,
                                        nil];
        self.context = aContext;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*)self.layer;
        
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:NO],
                                        kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyColorFormat,
                                        nil];
    }
    
    return self;
}

- (void)setContext:(EAGLContext *)aContext {
    if(_glContext == aContext) {
        return;
    }
    
    [EAGLContext setCurrentContext:_glContext];
    
    [self clearContext];
    
    _glContext = aContext;
        
    if(nil != _glContext) {
        [EAGLContext setCurrentContext:_glContext];
            
        glGenFramebuffers(1, &_defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
            
        glGenRenderbuffers(1, &_colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
            
        glFramebufferRenderbuffer(GL_FRAMEBUFFER,
                                  GL_COLOR_ATTACHMENT0,
                                  GL_RENDERBUFFER,
                                  _colorRenderbuffer);
            
        [self layoutSubviews];
    }
}

- (EAGLContext*)context {
    return _glContext;
}

- (void)render {
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);
    
    [self drawRect:self.bounds];
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect {
    if(self.delegate) {
        [self.delegate renderView:self renderInRect:rect];
    }
}

- (void)layoutSubviews {
    CAEAGLLayer *eaglLayer = (CAEAGLLayer*)self.layer;
    
    [EAGLContext setCurrentContext:self.context];
    
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    if(0 != _depthRenderbuffer) {
        glDeleteRenderbuffers(1, &_depthRenderbuffer);
        _depthRenderbuffer = 0;
    }
    
    GLint currentDrawableWidth  = self.drawableWidth;
    GLint currentDrawableHeight = self.drawableHeight;
    
    if(0 < currentDrawableWidth && 0 < currentDrawableHeight) {
        glGenRenderbuffers(1, &_depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER,
                              GL_DEPTH_COMPONENT16,
                              currentDrawableWidth,
                              currentDrawableHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER,
                                  GL_DEPTH_ATTACHMENT,
                                  GL_RENDERBUFFER,
                                  _depthRenderbuffer);
    }
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(GL_FRAMEBUFFER_COMPLETE != status) {
        NSLog(@"Failed to make complete frame buffer object %x", status);
    }
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
}

- (GLint)drawableWidth {
    GLint backingWith;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_WIDTH,
                                 &backingWith);
    
    return backingWith;
}

- (GLint)drawableHeight {
    GLint backingHeight;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_HEIGHT,
                                 &backingHeight);
    
    return backingHeight;
}

- (void)clearContext {
    if(0 != _defaultFramebuffer) {
        glDeleteFramebuffers(1, &_defaultFramebuffer);
        _defaultFramebuffer = 0;
    }
    
    if(0 != _colorRenderbuffer) {
        glDeleteRenderbuffers(1, &_colorRenderbuffer);
        _colorRenderbuffer = 0;
    }
    
    if(0 != _depthRenderbuffer) {
        glDeleteRenderbuffers(1, &_depthRenderbuffer);
        _depthRenderbuffer = 0;
    }
    
    _glContext = nil;
}

- (void)dealloc {
    if([EAGLContext currentContext] == _glContext) {
        [EAGLContext setCurrentContext: nil];
    }
}

@end
