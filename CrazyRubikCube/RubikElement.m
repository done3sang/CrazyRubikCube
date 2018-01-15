//
//  RubikElement.m
//  CrazyRubikCube
//
//  Created by xy on 19/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "Transform.h"
#import "SceneNode.h"
#import "GeometryMaker.h"
#import "GeometryMesh.h"
#import "RubikElement.h"
#import "Camera.h"
#import "Director.h"
#ifdef DEBUG
#import "Profile.h"
#endif

@implementation RubikElement

@synthesize rubikIndex = _rubikIndex;

- (instancetype)initWithElement:(size_t)rubikIndex elementPosition:(GLKVector3)position {
    if(self = [super init]) {
        [self doRuibkElement:rubikIndex elementPosition:position];
    }
    
    return self;
}

+ (RubikElement*)rubikElement:(size_t)rubikIndex elementPosition:(GLKVector3)position {
    return [[RubikElement alloc] initWithElement:rubikIndex elementPosition:position];
}

- (void)doRuibkElement:(size_t)rubikIndex elementPosition:(GLKVector3)position {
    _rubikIndex = rubikIndex;
    _transform.position = position;
    _geometry = [[GeometryMaker sharedGeometryMaker] geometryMeshByName:@"roundCube"];
}

- (void)updateSelf:(float)deltaTime {
    
}

- (void)renderSelf:(GLKMatrix4)modelMatrix {
#ifdef DEBUG
    [[Profile sharedProfile] beginSample:@"Rubik Element Render"];
#endif
    
    if(nil == _geometry) {
        return;
    }
    
    [_geometry prepareToRender];
    
    Camera *mainCamera = [Director sharedDirector].mainCamera;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(mainCamera.viewMatrix, modelMatrix);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(mainCamera.projectionMatrix, modelViewMatrix);
    
    [_geometry uniformMatrix4:"u_mvpMatrix" uniformMatrix:modelViewProjectionMatrix];
    [_geometry uniformMatrix3:"u_normalMatrix" uniformMatrix:normalMatrix];
    
    [_geometry render];
    
#ifdef DEBUG
    [[Profile sharedProfile] endSample:@"Rubik Element Render"];
#endif
}

@end
