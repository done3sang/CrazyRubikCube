//
//  Plane.h
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Plane : NSObject {
    GLKVector3 _normal;
    float _distance;
}

@property (nonatomic, readonly) GLKVector3 normal;
@property (nonatomic, readonly) float distance;

//- (GLKVector3)closestPoint_PointPlane:(GLKVector3)point;

@end
