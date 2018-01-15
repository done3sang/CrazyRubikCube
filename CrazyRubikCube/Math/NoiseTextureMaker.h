//
//  NoiseTextureMaker.h
//  CrazyRubikCube
//
//  Created by xy on 07/02/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoiseTextureMaker : NSObject

+ (int)generate2DTexture:(int)texWidth textureHeight:(int)texHeight;

+ (float)noise:(float)x positionY:(float)y positionZ:(float)z;

@end
