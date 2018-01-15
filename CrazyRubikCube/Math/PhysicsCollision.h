//
//  PhysicsCollision.h
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Ray;
@class AxisAlignedBoundingBox;
@class SphereBoundingVolume;
@class OrientedBoundingBox;

@interface PhysicsCollision : NSObject

+ (BOOL)testAABBAABB:(AxisAlignedBoundingBox*)a other:(AxisAlignedBoundingBox*)b;

+ (BOOL)testSphereSphere:(SphereBoundingVolume*)a other:(SphereBoundingVolume*)b;

+ (BOOL)testOBBOBB:(OrientedBoundingBox*)a other:(OrientedBoundingBox*)b;

+ (BOOL)testRaySphere:(Ray*)ray sphere:(SphereBoundingVolume*)sphere;

+ (BOOL)intersectRaySphere:(Ray*)ray sphere:(SphereBoundingVolume*)sphere intersectPoint:(GLKVector3*)intersection;

+ (BOOL)intersectRayAABB:(Ray*)ray axisAlignedBoundingBox:(AxisAlignedBoundingBox*)aabb intersectPoint:(GLKVector3*)intersection;

+ (BOOL)intersectRayOBB:(Ray*)ray orientedBoundingBox:(OrientedBoundingBox*)obb intersectPoint:(GLKVector3*)intersection;

@end
