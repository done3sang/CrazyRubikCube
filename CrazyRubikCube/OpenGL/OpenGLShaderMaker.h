//
//  OpenGLShaderMaker.h
//  CrazyRubikCube
//
//  Created by xy on 04/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

@interface OpenGLShaderMaker : NSObject {
    NSMutableDictionary *_programDict;
    NSDictionary *_vertexShaderDict;
    NSDictionary *_fragmentShaderDict;
}

+ (instancetype)sharedShaderMaker;

- (GLuint)shaderProgramByName:(NSString*)shaderName;

@end
