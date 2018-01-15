//
//  OpenGLMaker.h
//  CrazyRubikCube
//
//  Created by xy on 05/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface OpenGLMaker : NSObject {
    EAGLContext *_context;
}

@property (nonatomic, strong) EAGLContext *context;

+ (OpenGLMaker*)sharedOpenGLMaker;

- (instancetype)initOpenGL;

- (void)setupOpenGL;

- (void)tearOpenGL;

@end
