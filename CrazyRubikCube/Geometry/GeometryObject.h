//
//  GeometryObject.h
//  CrazyRubikCube
//
//  Created by xy on 05/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface GeometryObject : NSObject {
    int _totalSize;
    int _stride;
    int _positionCount;
    int _normalCount;
    int _texCoordCount;
    NSData *_objectData;
}

@property (nonatomic, readonly) int totalSize;

@property (nonatomic, readonly) int stride;

@property (nonatomic, readonly) int positionCount;

@property (nonatomic, readonly) int normalCount;

@property (nonatomic, readonly) int texCoordCount;

- (const float*)getData;

@end
