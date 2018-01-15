//
//  GeometryMaker.m
//  CrazyRubikCube
//
//  Created by xy on 23/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import "GeometryMaker.h"
#import "GeometryMesh.h"
#import "OpenGLShaderMaker.h"

@implementation GeometryMaker

static GeometryMaker *_sharedMaker = nil;

+ (GeometryMaker*)sharedGeometryMaker {
    if(nil == _sharedMaker) {
        _sharedMaker = [[GeometryMaker alloc] init];
    }
    
    return _sharedMaker;
}

- (instancetype)init {
    if(self = [super init]) {
        [self initMaker];
    }
    
    return self;
}

- (GeometryMesh*)geometryMeshByName:(NSString *)meshName {
    GeometryMesh *mesh = [_meshDict objectForKey:meshName];
    
    if(nil == mesh) {
        mesh = [self loadMeshByName:meshName];
    }
    
    return mesh;
}

- (GeometryMesh*)loadMeshByName:(NSString*)meshName {
    GeometryMesh *mesh = [GeometryMesh meshWithVertexAndProgram:
                          [[OpenGLShaderMaker sharedShaderMaker] shaderProgramByName:meshName]
                                                     vertexData:[self dataByName:meshName]];
    
    return mesh;
}

- (void)initMaker {
    _meshDict = [[NSMutableDictionary alloc] init];
}

- (void)tearMaker {
    [_meshDict removeAllObjects];
    _meshDict = nil;
}

- (NSData*)dataByName:(NSString*)dataName {
    NSData *data = [_meshDict objectForKey:dataName];
    
    if(nil == data) {
        data = [self loadDataByName:dataName];
    }
    
    return data;
}

- (NSData*)loadDataByName:dataName {
    NSData *data = nil;
    
    if([dataName isEqualToString:@"roundCube"]) {
        data = [self sharpCubeData];
    }
    
    return data;
}

- (NSData*)sharpCubeData {
        // position, normal, texture coordinate(last componet inspect pattern)
        float cubeArray[] = {
            // front
            -0.5f, -0.5f, 0.50f,    0.00f, 0.00f, 1.00f,    0.0f, 0.0f,
            0.50f, -0.5f, 0.50f,    0.00f, 0.00f, 1.00f,    1.0f, 0.0f,
            0.50f, 0.50f, 0.50f,    0.00f, 0.00f, 1.00f,    1.0f, 1.0f,
            -0.5f, -0.5f, 0.50f,    0.00f, 0.00f, 1.00f,    0.0f, 0.0f,
            0.50f, 0.50f, 0.50f,    0.00f, 0.00f, 1.00f,    1.0f, 1.0f,
            -0.5f, 0.50f, 0.50f,    0.00f, 0.00f, 1.00f,    0.0f, 1.0f,
            
            // top
            -0.5f, 0.50f, 0.50f,    0.00f, 1.00f, 0.00f,    0.0f, 1.0f,
            0.50f, 0.50f, 0.50f,    0.00f, 1.00f, 0.00f,    1.0f, 1.0f,
            0.50f, 0.50f, -0.5f,    0.00f, 1.00f, 0.00f,    1.0f, 0.0f,
            -0.5f, 0.50f, 0.50f,    0.00f, 1.00f, 0.00f,    0.0f, 1.0f,
            0.50f, 0.50f, -0.5f,    0.00f, 1.00f, 0.00f,    1.0f, 0.0f,
            -0.5f, 0.50f, -0.5f,    0.00f, 1.00f, 0.00f,    0.0f, 0.0f,
            
            // back
            0.50f, 0.50f, -0.5f,    0.00f, 0.00f, -1.0f,    1.0f, 0.0f,
            0.50f, -0.5f, -0.5f,    0.00f, 0.00f, -1.0f,    1.0f, 1.0f,
            -0.5f, -0.5f, -0.5f,    0.00f, 0.00f, -1.0f,    0.0f, 1.0f,
            -0.5f, 0.50f, -0.5f,    0.00f, 0.00f, -1.0f,    0.0f, 0.0f,
            0.50f, 0.50f, -0.5f,    0.00f, 0.00f, -1.0f,    1.0f, 0.0f,
            -0.5f, -0.5f, -0.5f,    0.00f, 0.00f, -1.0f,    0.0f, 1.0f,
            
            // bottom
            -0.5f, -0.5f, -0.5f,    0.00f, -1.0f, 1.00f,    0.0f, 1.0f,
            0.50f, -0.5f, -0.5f,    0.00f, -1.0f, 1.00f,    1.0f, 1.0f,
            -0.5f, -0.5f, 0.50f,    0.00f, -1.0f, 1.00f,    0.0f, 0.0f,
            -0.5f, -0.5f, 0.50f,    0.00f, -1.0f, 1.00f,    0.0f, 0.0f,
            0.50f, -0.5f, -0.5f,    0.00f, -1.0f, 1.00f,    1.0f, 1.0f,
            0.50f, -0.5f, 0.50f,    0.00f, -1.0f, 1.00f,    1.0f, 0.0f,
            
            // left
            -0.5f, -0.5f, -0.5f,    -1.0f, 0.00f, 0.00f,    1.0f, 0.0f,
            -0.5f, -0.5f, 0.50f,    -1.0f, 0.00f, 0.00f,    0.0f, 0.0f,
            -0.5f, 0.50f, 0.50f,    -1.0f, 0.00f, 0.00f,    0.0f, 1.0f,
            -0.5f, 0.50f, 0.50f,    -1.0f, 0.00f, 0.00f,    0.0f, 1.0f,
            -0.5f, 0.50f, -0.5f,    -1.0f, 0.00f, 0.00f,    1.0f, 1.0f,
            -0.5f, -0.5f, -0.5f,    -1.0f, 0.00f, 0.00f,    1.0f, 0.0f,
            
            // right
            0.50f, -0.5f, -0.5f,    1.00f, 0.00f, 0.00f,    0.0f, 0.0f,
            0.50f, -0.5f, 0.50f,    1.00f, 0.00f, 0.00f,    1.0f, 0.0f,
            0.50f, 0.50f, 0.50f,    1.00f, 0.00f, 0.00f,    1.0f, 1.0f,
            0.50f, 0.50f, 0.50f,    1.00f, 0.00f, 0.00f,    1.0f, 1.0f,
            0.50f, -0.5f, -0.5f,    1.00f, 0.00f, 0.00f,    0.0f, 0.0f,
            0.50f, 0.50f, -0.5f,    1.00f, 0.00f, 0.00f,    0.0f, 1.0f
        };
        
    NSData *cubeData = [NSData dataWithBytes:cubeArray length:(6 * 2 * 3 * 8 * sizeof(float))];
    
    return cubeData;
}

@end
