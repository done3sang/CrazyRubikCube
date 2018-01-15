//
//  RubikElement.h
//  CrazyRubikCube
//
//  Created by xy on 19/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "SceneNode.h"

@interface RubikElement : SceneNode {
    size_t _rubikIndex;
}

@property (nonatomic, assign) size_t rubikIndex;

- (instancetype)initWithElement:(size_t)rubikIndex elementPosition:(GLKVector3)position;

+ (RubikElement*)rubikElement:(size_t)rubikIndex elementPosition:(GLKVector3)position;

- (void)doRuibkElement:(size_t)rubikIndex elementPosition:(GLKVector3)position;

- (void)updateSelf:(float)deltaTime;

- (void)renderSelf:(GLKMatrix4)modelViewMatrix;

@end
