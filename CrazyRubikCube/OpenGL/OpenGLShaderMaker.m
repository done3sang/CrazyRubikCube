//
//  OpenGLShaderMaker.m
//  CrazyRubikCube
//
//  Created by xy on 04/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "OpenGLShaderMaker.h"
#import "OpenGLShaderLoader.h"

@implementation OpenGLShaderMaker

static OpenGLShaderMaker *_sharedShaderMaker = nil;

+ (instancetype)sharedShaderMaker {
    if(nil == _sharedShaderMaker) {
        _sharedShaderMaker = [[OpenGLShaderMaker alloc] init];
    }
    
    return _sharedShaderMaker;
}

- (instancetype)init {
    if(self = [super init]) {
        [self initMaker];
    }
    
    return self;
}

- (GLuint)shaderProgramByName:(NSString *)shaderName {
    NSNumber *value = [_programDict objectForKey:shaderName];
    GLuint programID = 0;
    
    if(nil == value) {
        programID = [self loadShaderByName:shaderName];
    } else {
        programID = [value unsignedIntValue];
    }
    
    return programID;
}

- (GLuint)loadShaderByName:(NSString*)shaderName {
    NSString *vertexPath    = [_vertexShaderDict objectForKey:shaderName];
    NSString *fragmentPath  = [_fragmentShaderDict objectForKey:shaderName];
    
    if(nil == vertexPath || nil == fragmentPath) {
        return 0;
    }
    
    GLuint programID = [OpenGLShaderLoader programFromFiles:vertexPath fragmentFile:fragmentPath];
    
    if(0 == programID) {
        return 0;
    }
    
    [_programDict setObject:[NSNumber numberWithUnsignedInt:programID] forKey:shaderName];
    
    return programID;
}

- (void)initMaker {
    _programDict = [[NSMutableDictionary alloc] init];
    _vertexShaderDict = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Shaders/roundCube.vsh", @"roundCube",
                         nil];
    _fragmentShaderDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Shaders/roundCube.fsh", @"roundCube",
                           nil];
}

- (void)tearMarker {
    for(id key in _programDict) {
        NSNumber *value = [_programDict objectForKey:key];
        glDeleteProgram([value unsignedIntValue]);
    }
    
    [_programDict removeAllObjects];
}

- (void)dealloc {
    [self tearMarker];
}

@end
