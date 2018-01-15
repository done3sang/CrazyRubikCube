//
//  RubikBlock.m
//  CrazyRubikCube
//
//  Created by xy on 12/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "Transform.h"
#import "SceneNode.h"
#import "RubikElement.h"
#import "BoundingVolume.h"
#import "AxisAlignedBoundingBox.h"
#import "RubikBlock.h"
#import "RubikTouch.h"
#import "Ray.h"
#import "PhysicsCollision.h"
#import "MathUtil.h"

@implementation RubikBlock

@synthesize blockOrientation = _blockOrientation;
@synthesize blockIndex = _blockIndex;
@synthesize blockSize = _blockSize;
@synthesize boundingVolume = _boundingVolume;

- (instancetype)initWithBlock:(RubikBlockOrientation)orientation
                blockPosition:(GLKVector3)position
                   blockIndex:(size_t)index
                    blockSize:(size_t)size
               blockDimension:(size_t)dimension
                   blockArray:(NSArray *)array {
    if(self = [super init]) {
        _blockOrientation = orientation;
        _blockIndex = index;
        _blockSize = size;
        _blockDimension = dimension;
        _blockArray = array;
        _transform.position = position;
        
        [self flushBlock];
    }
    
    return self;
}

+ (RubikBlock*)blockWithBlock:(RubikBlockOrientation)orientation
                blockPosition:(GLKVector3)position
                   blockIndex:(size_t)index
                    blockSize:(size_t)size
               blockDimension:(size_t)dimension
                   blockArray:(NSArray *)array {
    return [[RubikBlock alloc] initWithBlock:orientation
                               blockPosition:position
                                  blockIndex:index
                                   blockSize:size
                              blockDimension:dimension
                                  blockArray:array];
}

+ (RubikBlock*)block {
    return [[RubikBlock alloc] init];
}

- (void)flushBlock {
    //NSAssert(RubikBlockOrientationNone != _blockOrientation, @"ERROR: RubikBlock.flushBlock, argument wrong");
    NSAssert(0 < _blockSize, @"ERROR: RubikBlock.flushBlock, argument wrong");
    NSAssert(0 < _blockArray.count, @"ERROR: RubikBlock.flushBlock, argument wrong");
    
    [self generateChildren];
    [self generateBoundingBox];
}

- (void)generateChildren {
    for (RubikElement *elem in _blockArray) {
        [self attachChild:elem];
    }
}

- (void)generateBoundingBox {
    float minx, miny, minz;
    GLKVector3 minPoint, maxPoint;
    
    minz = -(float)_blockDimension/2.0f;
    miny = -(float)_blockSize/2.0f;
    minx = minz;
    
    if(RubikBlockOrientationVertical == _blockOrientation) {
        minx = miny;
        miny = minz;
    }
    
    minPoint = GLKVector3Make(minx, miny, minz);
    maxPoint = GLKVector3Negate(minPoint);
    
    _boundingVolume = [AxisAlignedBoundingBox AABBWithAABB:minPoint maxPoint:maxPoint];
}

- (BOOL)intersectRayAndBlock:(Ray *)ray intersectionPoint:(GLKVector3 *)intersection {
    Ray *localRay = [Ray rayWithRay:ray.origin direction:ray.direction];
    localRay.origin = [_transform world2LocalPoint:localRay.origin];
    localRay.direction = [_transform world2LocalDirection:localRay.direction];
    
    return [PhysicsCollision intersectRayAABB:localRay
                       axisAlignedBoundingBox:_boundingVolume
                               intersectPoint:intersection];
}

- (void)doPanBlock:(RubikTouch *)touch worldTranslation:(GLKVector3)translation {
    GLKVector3 localDir = [self world2NodeDirection:translation];
    float dx = localDir.x;
    float dy = localDir.y;
    
    if(![self isDividable]) {
        [self panBlock:touch localTranslation:localDir];
        return;
    }
    
    // vertical pan
    if(fabsf(dx) < fabsf(dy)) {
        if(RubikBlockOrientationNone == _blockOrientation) {
            size_t divideLocation = [self pointToLocationHorizontal:touch.intersection];
            size_t divideSize = [self isValueInJoint:touch.intersection.x jointSize:_blockSize] ? 2: 1;
            RubikBlock *rb = [self divideBlock:RubikBlockOrientationVertical
                                divideLocation:divideLocation
                                    divideSize:divideSize];
            
            GLKVector3 intersection = [touch.touchedBlock node2WorldPoint:touch.intersection];
            touch.intersection = [rb world2NodePoint:intersection];
            touch.touchedBlock = rb;
            [rb panBlock:touch localTranslation:localDir];
        } else if(RubikBlockOrientationVertical == _blockOrientation) {
            size_t divideSize = [self isValueInJoint:touch.intersection.x jointSize:_blockSize] ? 2: 1;
            
            if(_blockSize <= divideSize) {
                [self panBlock:touch localTranslation:localDir];
            } else {
                size_t divideLocation = [self pointToLocationHorizontal:touch.intersection];
                RubikBlock *rb = [self divideBlock:RubikBlockOrientationVertical
                                    divideLocation:divideLocation
                                        divideSize:divideSize];
                
                GLKVector3 intersection = [touch.touchedBlock node2WorldPoint:touch.intersection];
                touch.intersection = [rb world2NodePoint:intersection];
                touch.touchedBlock = rb;
                [rb panBlock:touch localTranslation:localDir];
            }
        } else {
            // warning
        }
    } else {
        if(RubikBlockOrientationNone == _blockOrientation) {
            size_t divideLocation = [self pointToLocationVertical:touch.intersection];
            size_t divideSize = [self isValueInJoint:touch.intersection.y jointSize:_blockSize] ? 2: 1;
            RubikBlock *rb = [self divideBlock:RubikBlockOrientationHorizontal
                                divideLocation:divideLocation
                                    divideSize:divideSize];
            
            GLKVector3 intersection = [touch.touchedBlock node2WorldPoint:touch.intersection];
            touch.intersection = [rb world2NodePoint:intersection];
            touch.touchedBlock = rb;
            [rb panBlock:touch localTranslation:localDir];
        } else if(RubikBlockOrientationHorizontal == _blockOrientation) {
            size_t divideSize = [self isValueInJoint:touch.intersection.y jointSize:_blockSize] ? 2: 1;
            
            if(_blockSize <= divideSize) {
                [self panBlock:touch localTranslation:localDir];
            } else {
                size_t divideLocation = [self pointToLocationVertical:touch.intersection];
                RubikBlock *rb = [self divideBlock:RubikBlockOrientationHorizontal
                                    divideLocation:divideLocation
                                        divideSize:divideSize];
                
                GLKVector3 intersection = [touch.touchedBlock node2WorldPoint:touch.intersection];
                touch.intersection = [rb world2NodePoint:intersection];
                touch.touchedBlock = rb;
                [rb panBlock:touch localTranslation:localDir];
            }
        } else {
            // warning
        }
    }
}

- (void)panBlock:(RubikTouch*)touch localTranslation:(GLKVector3)translation {
    NSAssert(touch.touchedBlock == self, @"ERROR: RubikBlock.panBlock, argument TOUCH dismatched");
    NSAssert(RubikBlockOrientationNone != _blockOrientation, @"ERROR: RubikBlock.panBlock, Orientation be NONE");
    
    if(RubikBlockOrientationHorizontal == _blockOrientation) {
        self.transform.yRotation += GLKMathDegreesToRadians(translation.x);
    } else {
        self.transform.xRotation += GLKMathDegreesToRadians(translation.y);
    }
}

- (size_t)pointToLocationVertical:(GLKVector3)point {
    float halfSpan = (RubikBlockOrientationHorizontal == _blockOrientation) ? (float)_blockSize: (float)_blockDimension;
    
    halfSpan *= 0.5f;
    
    return (size_t)floorf(halfSpan + point.y);
}

- (size_t)pointToLocationHorizontal:(GLKVector3)point {
    float halfSpan = (RubikBlockOrientationVertical == _blockOrientation) ? (float)_blockSize: (float)_blockDimension;
    
    halfSpan *= 0.5f;
    
    return (size_t)floorf(halfSpan + point.x);
}

- (BOOL)isValueInJoint:(float)fv jointSize:(float)jointSize {
    fv += (float)jointSize * 0.5f;
    
    float rv = roundf(fv);
    float interval = 0.05f;
    
    return 0.5f < fv && fv < (float)jointSize - 0.5f &&
        [MathUtil interval:fv beginValue:rv - interval endValue:rv + interval];
}

-(BOOL)isDividable {
    return 1 < _blockSize;
}

- (RubikBlock*)divideBlock:(RubikBlockOrientation)orientation
            divideLocation:(size_t)location
                divideSize:(size_t)size {
    NSAssert(RubikBlockOrientationNone != orientation, @"ERROR: RubikBlock.divideBlock, argument wrong");
    NSAssert(RubikBlockOrientationNone == _blockOrientation || _blockOrientation == orientation,
             @"ERROR: RubikBlock.divideBlock, argument wrong");
    NSAssert(location + size <= _blockSize, @"ERROR: RubikBlock.divideBlock, argument wrong");
    
    if(![self isDividable]) {
        return nil;
    }
    
    _blockOrientation = orientation;
    
    if(0 == location && _blockSize == size) {
        return self;
    }
    
    size_t part0Loc = 0;
    size_t part0Size = location;
    size_t part1Loc = location;
    size_t part1Size = size;
    size_t part2Loc = location + size;
    size_t part2Size = _blockSize - part2Loc;
    
    NSMutableArray *part0 = [self elementsByLocationAndSize:part0Loc size:part0Size];
    NSMutableArray *part1 = [self elementsByLocationAndSize:part1Loc size:part1Size];
    NSMutableArray *part2 = [self elementsByLocationAndSize:part2Loc size:part2Size];
    
    NSAssert(part0 || part1 || part2, @"ERROR: RubikBlock.divideBlock, something's going wrong in dividing");
    
    NSMutableArray *partArr = [NSMutableArray array];
    size_t partRect[6];
    size_t partIndex = 0;
    
    if(part0) {
        [partArr addObject:part0];
        partRect[partIndex++] = part0Loc;
        partRect[partIndex++] = part0Size;
    }
    
    if(part1) {
        [partArr addObject:part1];
        partRect[partIndex++] = part1Loc;
        partRect[partIndex++] = part1Size;
    }
    
    if(part2) {
        [partArr addObject:part2];
        partRect[partIndex++] = part2Loc;
        partRect[partIndex++] = part2Size;
    }
    
    size_t partLoc, partSize;
    RubikBlock *targetBlock = (0 == location) ? self: nil;
    float partOffset = 0.0f;
    GLKVector3 blockOffset = GLKVector3Make(0.0f, 0.0f, 0.0f);
    
    partIndex = 1;
    
    for(size_t index = 1; index < [partArr count]; ++index) {
        RubikBlock *block = [self copy];
        
        partLoc = partRect[++partIndex];
        partSize = partRect[++partIndex];
        
        block.blockIndex = _blockIndex + partLoc;
        block.blockSize = partSize;
        block.blockArray = [partArr objectAtIndex:index];
        
        partOffset = [self partitionOffset:partLoc partSize:partSize];
        
        if(RubikBlockOrientationHorizontal == _blockOrientation) {
            blockOffset.x = 0.0f;
            blockOffset.y = partOffset;
        } else {
            blockOffset.x = partOffset;
            blockOffset.y = 0.0f;
        }
        [block.transform translate:blockOffset];
        [block flushBlock];
        
        if(nil == targetBlock) {
            targetBlock = block;
        }
    }
    
    NSMutableArray *blockArr = [partArr objectAtIndex:0];
    
    partLoc = partRect[0];
    partSize = partRect[1];
    
    partOffset = [self partitionOffset:partLoc partSize:partSize];
    
    if(RubikBlockOrientationHorizontal == _blockOrientation) {
        blockOffset.x = 0.0f;
        blockOffset.y = partOffset;
    } else {
        blockOffset.x = partOffset;
        blockOffset.y = 0.0f;
    }
    [_transform translate:blockOffset];
    
    _blockIndex += partLoc;
    _blockSize = partSize;
    _blockArray = blockArr;
    
    blockOffset = GLKVector3Negate(blockOffset);
    for(RubikElement *re in _children) {
        [re.transform translate:blockOffset];
    }
    [self generateBoundingBox];
    
    return targetBlock;
}

- (float)partitionOffset:(float)partLoc partSize:(float)partSize {
    return -0.5f * _blockSize + (partLoc + 0.5f * partSize);
}

- (NSMutableArray*)elementsByLocationAndSize:(size_t)location
                                        size:(size_t)size {
    NSAssert(RubikBlockOrientationNone != _blockOrientation, @"ERROR: RubikBlock.divideBlock, argument wrong");
    NSAssert(location + size <= _blockSize, @"ERROR: RubikBlock.divideBlock, argument wrong");
    
    if(0 == size) {
        return nil;
    }
    
    if(0 == location && _blockSize == size) {
        return _children;
    }
    
    NSMutableArray *elementArr = [NSMutableArray array];
    size_t xStart, xEnd, yStart, yEnd;
    
    if(RubikBlockOrientationHorizontal == _blockDimension) {
        xStart = 0;
        xEnd = _blockDimension;
        
        yStart = location;
        yEnd = xStart + size;
    } else {
        xStart = location;
        xEnd = xStart + size;
        
        yStart = 0;
        yEnd = _blockDimension;
    }
    
    size_t xyCount = _blockDimension * _blockSize;
    
    for(size_t zIndex = 0; zIndex < _blockDimension; ++zIndex) {
        for(size_t yIndex = yStart; yIndex < yEnd; ++yIndex) {
            for(size_t xIndex = xStart; xIndex < xEnd; ++xIndex) {
                [elementArr addObject:[self getChild:zIndex * xyCount + yIndex * _blockSize + xIndex]];
            }
        }
    }
    
    return elementArr;
}

- (id)copyWithZone:(NSZone *)zone {
    RubikBlock *block = [[RubikBlock alloc] init];
    
    block.transform = [_transform copy];
    block.geometry = _geometry;
    block.blockOrientation = _blockOrientation;
    block.blockDimension = _blockDimension;
    
    if(_parent) {
        [_parent attachChild:block];
    }
    
    return block;
}

@end
