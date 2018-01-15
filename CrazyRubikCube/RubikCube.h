//
//  RubikCube.h
//  CrazyRubikCube
//
//  Created by xy on 20/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class SceneNode;
@class SphereBoundingVolume;
@class RubikTouch;

@interface RubikCube : SceneNode {
    size_t _dimension;
    float _halfSpan;
    
    GLKMatrix4 _woodSliceMatrix;
    GLKVector4 _woodDarkColor;
    GLKVector4 _woodLightColor;
    GLuint _woodNoiseTextureID;
    
    SphereBoundingVolume *_boundingVolume;
    NSMutableArray *_rubikTouches;
    GLKMatrix4 _worldMatrix;
    BOOL _touchInside;
}

@property (nonatomic, readonly) size_t dimension;
@property (nonatomic, readonly, strong, nonnull) SphereBoundingVolume *boundingVolume;
@property (nonatomic, readonly) BOOL touchInside;

- (nonnull instancetype)initWithDimension:(size_t)dimension;

+ (nonnull RubikCube*)rubikWithDimension:(size_t)dimension;

- (void)setupRubik:(size_t)dimension;

@end
