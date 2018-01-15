//
//  OpenGLShaderLoader.m
//  CrazyRubikCube
//
//  Created by xy on 20/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import "OpenGLShaderLoader.h"

const GLuint kShaderVertexAttribPosition    = 1;
const GLuint kShaderVertexAttribNormal      = 2;
const GLuint kShaderVertexAttribTexCoord0   = 3;
const GLuint kShaderVertexAttribColor       = 4;

@implementation OpenGLShaderLoader

+ (GLuint)shaderFromFile:(NSString*)pathName shaderType:(GLenum)shaderType {
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:pathName ofType:nil];
    
    if(nil == fullPath) {
        NSAssert(true, @"File not found: %@", pathName);
        return 0;
    }
    
    const char *shaderSource = [[NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if(!shaderSource) {
        NSAssert(true, @"File not found: %@", pathName);
        return 0;
    }
    
    return [OpenGLShaderLoader shaderFromSource:shaderSource shaderType:shaderType];
}

+ (GLuint)shaderFromSource:(const char *)shaderSource shaderType:(GLenum)shaderType {
    NSAssert(NULL != shaderSource, @"shader source cannot be invalid");
    
    GLint status;
    GLuint shaderID = glCreateShader(shaderType);
    
    glShaderSource(shaderID, 1, &shaderSource, NULL);
    glCompileShader(shaderID);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(shaderID, GL_INFO_LOG_LENGTH, &logLength);
    if(0 < logLength) {
        GLchar *log = (GLchar*)malloc(logLength);
        glGetShaderInfoLog(shaderID, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(shaderID, GL_COMPILE_STATUS, &status);
    if(0 == status) {
        glDeleteShader(shaderID);
        shaderID = 0;
    }
    
    return shaderID;
}

+ (GLuint)programFromFiles:(NSString*)vertexFile fragmentFile:(NSString*)fragmentFile {
    GLuint vertexShaderID, fragmentShaderID;
    
    vertexShaderID = [OpenGLShaderLoader shaderFromFile:vertexFile shaderType:GL_VERTEX_SHADER];
    fragmentShaderID = [OpenGLShaderLoader shaderFromFile:fragmentFile shaderType:GL_FRAGMENT_SHADER];
    
    if(0 == vertexShaderID || 0 == fragmentShaderID) {
        return 0;
    }
    
    NSArray *shaderArray = [NSArray arrayWithObjects:
                            [NSNumber numberWithUnsignedInt:vertexShaderID],
                            [NSNumber numberWithUnsignedInt:fragmentShaderID],
                            nil];
    
    GLuint programID = [OpenGLShaderLoader programFromShaders:shaderArray];
    
    glDetachShader(programID, vertexShaderID);
    glDeleteShader(vertexShaderID);
    
    glDetachShader(programID, fragmentShaderID);
    glDeleteShader(fragmentShaderID);
    
    return programID;
}

+ (GLuint)programFromShaders:(NSArray*)shaderArray {
    GLuint programID = glCreateProgram();
    
    for(NSNumber *number in shaderArray) {
        glAttachShader(programID, [number unsignedIntValue]);
    }
    
    [OpenGLShaderLoader bindAttribLocation:programID];
    
    if(![OpenGLShaderLoader linkProgram:programID]) {
        NSLog(@"Failed to link program: %d", programID);
        
        if(0 != programID) {
            glDeleteProgram(programID);
        }
        
        return 0;
    }
    
    for(NSNumber *number in shaderArray) {
        glDetachShader(programID, [number unsignedIntValue]);
    }
    
    return programID;
}

+ (void)bindAttribLocation:(GLuint)programID {
    glBindAttribLocation(programID, kShaderVertexAttribPosition, "a_position");
    glBindAttribLocation(programID, kShaderVertexAttribNormal, "a_normal");
    glBindAttribLocation(programID, kShaderVertexAttribTexCoord0, "a_texCoord0");
    glBindAttribLocation(programID, kShaderVertexAttribColor, "a_color");
}

+ (BOOL)linkProgram:(GLuint)programID {
    GLint status;
    
    glLinkProgram(programID);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(programID, GL_INFO_LOG_LENGTH, &logLength);
    if(0 < logLength) {
        GLchar *log = (GLchar*)malloc(logLength);
        glGetProgramInfoLog(programID, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(programID, GL_LINK_STATUS, &status);
    
    return 0 == status ? NO: YES;
}

+ (BOOL)validateProgram:(GLuint)programID {
    GLint logLength, status;
    
    glValidateProgram(programID);
    glGetProgramiv(programID, GL_INFO_LOG_LENGTH, &logLength);
    if(0 < logLength) {
        GLchar *log = (GLchar*)malloc(logLength);
        glGetProgramInfoLog(programID, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(programID, GL_VALIDATE_STATUS, &status);
    
    return 0 == status ? NO: YES;
}
@end
