//
//  OpenGLShaderLoader.h
//  CrazyRubikCube
//
//  Created by xy on 20/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

extern const GLuint kShaderVertexAttribPosition;
extern const GLuint kShaderVertexAttribNormal;
extern const GLuint kShaderVertexAttribTexCoord0;
extern const GLuint kShaderVertexAttribColor;

@interface OpenGLShaderLoader : NSObject

+ (GLuint)shaderFromFile:(NSString*)pathName shaderType:(GLenum)shaderType;

+ (GLuint)shaderFromSource:(const char*)shaderSource shaderType:(GLenum)shaderType;

+ (GLuint)programFromFiles:(NSString*)vertexFile fragmentFile:(NSString*)fragmentFile;

+ (GLuint)programFromShaders:(NSArray*)shaderArray;

@end
