//
//  GeometryMesh.h
//  CrazyRubikCube
//
//  Created by xy on 03/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface GeometryMesh : NSObject {
    GLuint _shaderProgramID;
    NSMutableDictionary *_shaderDict;
    
    GLuint _vertexArrayObjectID;
    
    GLuint _vertexBufferObjectID;
    GLsizei _vertexCount;
}

@property (nonatomic, assign) GLuint shaderProgramID;

- (instancetype)initWithVertexAndProgram:(GLuint)programID vertexData:(NSData*)vertexData;

+ (instancetype)meshWithVertexAndProgram:(GLuint)programID vertexData:(NSData*)vertexData;

- (void)clearMeshData;

- (void)setMeshData:(GLuint)shaderProgramID vertexData:(NSData*)vertexData;

- (void)setShaderProgramID:(GLuint)shaderProgramID;

- (GLuint)getShaderProgramID;

- (void)setVertexData:(NSData*)vertexData;

- (void)prepareToRender;

- (void)render;

- (int)uniformLocationByName:(const char*)uniformName;

- (int)attribLocationByName:(const char*)attribName;

- (void)uniformMatrix4:(const char*)uniformName uniformMatrix:(GLKMatrix4)uMatrix;

- (void)uniformMatrix3:(const char*)uniformName uniformMatrix:(GLKMatrix3)uMatrix;

- (void)uniform1i:(const char*)uniformName uniformValue:(int)value;

- (void)uniformVector3:(const char *)uniformName uniformVector:(GLKVector3)vec;

- (void)uniformVector4:(const char *)uniformName uniformVector:(GLKVector4)vec;

@end
