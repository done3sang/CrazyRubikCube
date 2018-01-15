//
//  OpenGLMaker.m
//  CrazyRubikCube
//
//  Created by xy on 05/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "OpenGLMaker.h"

@implementation OpenGLMaker

static OpenGLMaker *_sharedOpenGLMaker = nil;

@synthesize context = _context;

+ (OpenGLMaker*)sharedOpenGLMaker {
    if(nil == _sharedOpenGLMaker) {
        _sharedOpenGLMaker = [[OpenGLMaker alloc] initOpenGL];
    }
    
    return _sharedOpenGLMaker;
}

- (instancetype)initOpenGL {
    if(self = [super init]) {
        [self setupOpenGL];
    }
    
    return self;
}

- (void)setupOpenGL {
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if(!_context) {
        NSLog(@"Failed to create OpenGLES context");
    }
    
    [EAGLContext setCurrentContext:_context];
    
    glEnable(GL_DEPTH_TEST);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}

- (void)tearOpenGL {
    if([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)dealloc {
    [self tearOpenGL];
}

@end
