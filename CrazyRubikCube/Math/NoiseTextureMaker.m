//
//  NoiseTextureMaker.m
//  CrazyRubikCube
//
//  Created by xy on 07/02/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "NoiseTextureMaker.h"
#import "MathUtil.h"

static int permutation[] = {
    151,160,137,91,90,15,
    131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
    190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
    88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
    77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
    102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
    135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
    5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
    223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
    129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
    251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
    49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
    138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
    151,160,137,91,90,15,
    131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
    190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
    88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
    77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
    102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
    135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
    5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
    223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
    129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
    251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
    49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
    138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
};

@implementation NoiseTextureMaker

+ (int)generate2DTexture:(int)texWidth textureHeight:(int)texHeight {
    GLubyte *texData = (GLubyte*)malloc(texWidth * texHeight * 4);
    
    double xRange = 1.0;
    double yRange = 1.0;
    double xFactor = xRange/texWidth;
    double yFactor = yRange/texHeight;
    
    for(int oct = 0; oct < 4; ++oct) {
        for(int i = 0; i < texWidth; ++i) {
            for(int j = 0; j < texHeight; ++j) {
                float px = xFactor * i * 16.0f;
                float py = yFactor * j * 16.0f;
                float val = fabsf([NoiseTextureMaker noise:px positionY:py positionZ:0.0f]);
                
                texData[((j * texWidth + i) * 4) + oct] = (GLubyte)(val * 255.0f);
            }
        }
    }
    
    GLuint texID;
    glGenTextures(1, &texID);
    
    glBindTexture(GL_TEXTURE_2D, texID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, texData);
    
    free(texData);
    return texID;
}

+ (float)noise:(float)x positionY:(float)y positionZ:(float)z {
    int ix = (int)floorf(fmodf(x, 255.0f));
    int iy = (int)floorf(fmodf(y, 255.0f));
    int iz = (int)floorf(fmodf(z, 255.0f));
    
    x -= floorf(x);
    y -= floorf(y);
    z -= floorf(z);
    
    float u = [MathUtil fade:x];
    float v = [MathUtil fade:y];
    float w = [MathUtil fade:z];
    
    int a   = permutation[ix] + iy;
    int aa  = permutation[a] + iz;
    int ab  = permutation[a + 1] + iz;
    int b   = permutation[ix + 1] + iy;
    int ba  = permutation[b] + iz;
    int bb  = permutation[b + 1] + iz;
    
    return [MathUtil lerp:w
                    begin:[MathUtil lerp:v
                                   begin:[MathUtil lerp:u
                                                  begin:[NoiseTextureMaker grad:permutation[aa]
                                                                      positionX:x
                                                                      positionY:y
                                                                      positionZ:z]
                                                    end:[NoiseTextureMaker grad:permutation[ba]
                                                                      positionX:x - 1.0f
                                                                      positionY:y
                                                                      positionZ:z]]
                                     end:[MathUtil lerp:u
                                                  begin:[NoiseTextureMaker grad:permutation[ab]
                                                                      positionX:x
                                                                      positionY:y - 1.0f
                                                                      positionZ:z]
                                                    end:[NoiseTextureMaker grad:permutation[bb]
                                                                      positionX:x - 1.0f
                                                                      positionY:y - 1.0f
                                                                      positionZ:z]]]
                      end:[MathUtil lerp:v
                                   begin:[MathUtil lerp:u
                                                  begin:[NoiseTextureMaker grad:permutation[aa + 1]
                                                                      positionX:x
                                                                      positionY:y
                                                                      positionZ:z - 1.0f]
                                                    end:[NoiseTextureMaker grad:permutation[ba + 1]
                                                                      positionX:x - 1.0f
                                                                      positionY:y
                                                                      positionZ:z - 1.0f]]
                                     end:[MathUtil lerp:u
                                                  begin:[NoiseTextureMaker grad:permutation[ab + 1]
                                                                      positionX:x
                                                                      positionY:y - 1.0f
                                                                      positionZ:z - 1.0f]
                                                    end:[NoiseTextureMaker grad:permutation[bb + 1]
                                                                      positionX:x - 1.0f
                                                                      positionY:y - 1.0f
                                                                      positionZ:z - 1.0f]]]];
}

+ (float)grad:(int)hash positionX:(float)x positionY:(float)y positionZ:(float)z {
    int h = hash % 16;
    float u, v, r;
    
    u = (h < 8) ? x: y;
    v = (h < 4) ? y: ((h == 12 || h == 14) ? x: z);
    
    r = (h % 2 == 0) ? u: -u;
    r = (h % 4 == 0) ? (r + v): (r - v);
    
    return r;
}

@end
