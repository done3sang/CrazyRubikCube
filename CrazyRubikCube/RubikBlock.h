//
//  RubikBlock.h
//  CrazyRubikCube
//
//  Created by xy on 12/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RubikTypes.h"

@class SceneNode;
@class AxisAlignedBoundingBox;
@class RubikTouch;
@class Ray;

// from left to right, bottom to right, children sorted by index
@interface RubikBlock : SceneNode<NSCopying> {
    RubikBlockOrientation _blockOrientation;
    size_t _blockIndex;
    size_t _blockSize;
    size_t _blockDimension;
    NSArray *_blockArray;
    
    AxisAlignedBoundingBox *_boundingVolume;
}

@property (nonatomic, assign) RubikBlockOrientation blockOrientation;
@property (nonatomic, assign) size_t blockIndex;
@property (nonatomic, assign) size_t blockSize;
@property (nonatomic, assign) size_t blockDimension;
@property (nonatomic, strong, nonnull) NSArray *blockArray;
@property (nonatomic, readonly, strong, nonnull) AxisAlignedBoundingBox *boundingVolume;

- (nonnull instancetype)initWithBlock:(RubikBlockOrientation)orientation
                        blockPosition:(GLKVector3)position
                           blockIndex:(size_t)index
                            blockSize:(size_t)size
                       blockDimension:(size_t)dimension
                           blockArray:(nonnull NSArray*)array;

+ (nonnull RubikBlock*)blockWithBlock:(RubikBlockOrientation)orientation
                        blockPosition:(GLKVector3)position
                           blockIndex:(size_t)index
                            blockSize:(size_t)size
                       blockDimension:(size_t)dimension
                           blockArray:(nonnull NSArray*)array;

+ (nonnull RubikBlock*)block;

- (void)flushBlock;

- (nullable RubikBlock*)divideBlock:(RubikBlockOrientation)orientation
                     divideLocation:(size_t)location
                         divideSize:(size_t)size;

- (nonnull NSMutableArray*)elementsByLocationAndSize:(size_t)location
                                                size:(size_t)size;

- (nonnull id)copyWithZone:(nullable NSZone *)zone;

- (BOOL)intersectRayAndBlock:(nonnull Ray*)ray intersectionPoint:(nullable GLKVector3*)intersection;

- (void)doPanBlock:(nonnull RubikTouch*)touch worldTranslation:(GLKVector3)translation;

- (BOOL)isDividable;

@end
