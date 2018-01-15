//
//  GeometryMesh.m
//  CrazyRubikCube
//
//  Created by Sang on 03/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "GeometryMesh.h"
#import "OpenGLShaderLoader.h"

@implementation GeometryMesh

- (instancetype)initWithVertexAndProgram:(GLuint)programID vertexData:(NSData*)vertexData {
    if(self = [super init]) {
        [self setMeshData:programID vertexData:vertexData];
    }
    
    return self;
}

+ (instancetype)meshWithVertexAndProgram:(GLuint)programID vertexData:(NSData*)vertexData {
    return [[GeometryMesh alloc] initWithVertexAndProgram:programID vertexData:vertexData];
}

- (void)clearMeshData {
    if(0 != _vertexArrayObjectID) {
        glDeleteVertexArraysOES(1, &_vertexArrayObjectID);
        _vertexArrayObjectID = 0;
    }
    
    if (0 != _vertexBufferObjectID) {
        glDeleteBuffers(1, &_vertexBufferObjectID);
        _vertexBufferObjectID = 0;
    }
    
    if(0 != _shaderProgramID) {
        glDeleteProgram(_shaderProgramID);
        _shaderProgramID = 0;
    }
    
    _shaderDict = [[NSMutableDictionary alloc] init];
}

- (void)setMeshData:(GLuint)shaderProgramID vertexData:(NSData*)vertexData {
    NSAssert(shaderProgramID != 0 && vertexData, @"GeometryMesh.setMeshData: argument error");
    
    _shaderProgramID = shaderProgramID;
    _shaderDict = [[NSMutableDictionary alloc] init];
    
    [self bindShaderObject:vertexData];
}

- (void)setShaderProgramID:(GLuint)shaderProgramID {
    _shaderProgramID = shaderProgramID;
    _shaderDict = [[NSMutableDictionary alloc] init];
}

- (GLuint)getShaderProgramID {
    return _shaderProgramID;
}

- (void)setVertexData:(NSData*)vertexData {
    NSAssert(vertexData, @"GeometryMesh.setVertexData: argument error");
    
    if(0 != _vertexBufferObjectID) {
        glDeleteBuffers(1, &_vertexBufferObjectID);
        _vertexBufferObjectID = 0;
    }
    
    if(0 != _vertexArrayObjectID) {
        glDeleteVertexArraysOES(1, &_vertexArrayObjectID);
        _vertexArrayObjectID = 0;
    }
    
    [self bindShaderObject:vertexData];
}

- (void)prepareToRender {
    glBindVertexArrayOES(_vertexArrayObjectID);
    glUseProgram(_shaderProgramID);
}

- (void)render {
    glDrawArrays(GL_TRIANGLES, 0, _vertexCount);
}

- (int)uniformLocationByName:(const char *)uniformName {
    NSAssert(uniformName, @"ERROR:uniformLocationByName, empty uniformName");
    
    NSString *uniformStr = [NSString stringWithUTF8String:uniformName];
    NSNumber *value = [_shaderDict objectForKey:uniformStr];
    
    if(nil == value) {
        int location = glGetUniformLocation(_shaderProgramID, uniformName);
        value = [NSNumber numberWithInt:location];
        _shaderDict[uniformStr] = value;
    }
    
    return [value intValue];
}

- (int)attribLocationByName:(const char *)attribName {
    NSAssert(attribName, @"attribLocationByName, empty attribName");
    
    NSString *attribStr = [NSString stringWithUTF8String:attribName];
    NSNumber *value = [_shaderDict objectForKey:attribStr];
    
    if(nil == value) {
        int location = glGetAttribLocation(_shaderProgramID, attribName);
        value = [NSNumber numberWithInt:location];
        _shaderDict[attribStr] = value;
    }
    
    return [value intValue];
}

- (void)uniformMatrix4:(const char *)uniformName uniformMatrix:(GLKMatrix4)uMatrix {
    glUniformMatrix4fv([self uniformLocationByName:uniformName],
                       1,
                       GL_FALSE,
                       uMatrix.m);
}

- (void)uniformMatrix3:(const char *)uniformName uniformMatrix:(GLKMatrix3)uMatrix {
    glUniformMatrix3fv([self uniformLocationByName:uniformName],
                       1,
                       GL_FALSE,
                       uMatrix.m);
}

- (void)uniform1i:(const char *)uniformName uniformValue:(int)value {
    glUniform1i([self uniformLocationByName:uniformName], value);
}

- (void)uniformVector3:(const char *)uniformName uniformVector:(GLKVector3)vec {
    glUniform3fv([self uniformLocationByName:uniformName],
                 1,
                 vec.v);
}

- (void)uniformVector4:(const char *)uniformName uniformVector:(GLKVector4)vec {
    glUniform4fv([self uniformLocationByName:uniformName],
                 1,
                 vec.v);
}

- (void)bindShaderObject:(NSData*)vertexData {
    glGenBuffers(1, &_vertexBufferObjectID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferObjectID);
    glBufferData(GL_ARRAY_BUFFER, vertexData.length, vertexData.bytes, GL_STATIC_DRAW);
    
    glGenVertexArraysOES(1, &_vertexArrayObjectID);
    glBindVertexArrayOES(_vertexArrayObjectID);
    
    glEnableVertexAttribArray(kShaderVertexAttribPosition);
    glEnableVertexAttribArray(kShaderVertexAttribNormal);
    glEnableVertexAttribArray(kShaderVertexAttribTexCoord0);
    
    glVertexAttribPointer(kShaderVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          8 * sizeof(float),
                          NULL);
    glVertexAttribPointer(kShaderVertexAttribNormal,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          8 * sizeof(float),
                          NULL + 3 * sizeof(float));
    glVertexAttribPointer(kShaderVertexAttribTexCoord0,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          8 * sizeof(float),
                          NULL + 6 * sizeof(float));
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArrayOES(0);
    
    _vertexCount = (GLsizei)(vertexData.length/(8 * sizeof(float)));
}

- (void)dealloc {
    [self clearMeshData];
}

@end
