//
//  GeometryObject.m
//  CrazyRubikCube
//
//  Created by xy on 05/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "GeometryObject.h"

@implementation GeometryObject

@synthesize totalSize = _totalSize;

@synthesize stride = _stride;

@synthesize positionCount = _positionCount;

@synthesize normalCount = _normalCount;

@synthesize texCoordCount = _texCoordCount;

- (const float*)getData {
    return NULL;
}

@end
