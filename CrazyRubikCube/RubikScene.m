//
//  RubikScene.m
//  CrazyRubikCube
//
//  Created by xy on 19/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "SceneNode.h"
#import "Scene.h"
#import "RubikCube.h"
#import "RubikScene.h"

@implementation RubikScene

- (instancetype)init {
    if(self = [super init]) {
        [self initScene];
    }
    
    return self;
}

+ (RubikScene*)rubikScene {
    return [[RubikScene alloc] init];
}

- (void)initScene {
    [self attachChild:[RubikCube rubikWithDimension:3]];
}

@end
