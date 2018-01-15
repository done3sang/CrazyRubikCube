//
//  PhysicsCollision.m
//  CrazyRubikCube
//
//  Created by xy on 22/05/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import "PhysicsCollision.h"
#import "Ray.h"
#import "BoundingVolume.h"
#import "AxisAlignedBoundingBox.h"
#import "SphereBoundingVolume.h"
#import "OrientedBoundingBox.h"

@implementation PhysicsCollision

+ (BOOL)testAABBAABB:(AxisAlignedBoundingBox *)a other:(AxisAlignedBoundingBox *)b {
    NSAssert(nil != a || nil != b, @"Function PhysicsCollision/testAABB_AABB: argument nil");
    
    if(a.max.x < b.min.x|| b.max.x < a.min.x) {
        return NO;
    }
    
    if(a.max.y < b.min.y || b.max.y < a.min.y) {
        return NO;
    }
    
    if(a.max.z < b.min.z || b.max.z < a.min.z) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)testSphereSphere:(SphereBoundingVolume *)a other:(SphereBoundingVolume *)b {
    NSAssert(nil != a || nil != b, @"Function PhysicsCollision/testSphere_Sphere: argument nil");
    
    GLKVector3 d = GLKVector3Subtract(a.center, b.center);
    float dist2 = GLKVector3DotProduct(d, d);
    float radiusSum = a.radius + b.radius;
    
    return dist2 <= radiusSum * radiusSum;
}

+ (BOOL)testOBBOBB:(OrientedBoundingBox *)a other:(OrientedBoundingBox *)b {
    NSAssert(nil != a || nil != b, @"Function PhysicsCollision/testOBB_OBB: argument nil");
    
    float ra, rb;
    GLKMatrix3 rotation, absRotation;
    
    rotation.m00 = GLKVector3DotProduct(a.axes[0], b.axes[0]);
    rotation.m01 = GLKVector3DotProduct(a.axes[0], b.axes[1]);
    rotation.m02 = GLKVector3DotProduct(a.axes[0], b.axes[2]);
    rotation.m10 = GLKVector3DotProduct(a.axes[1], b.axes[0]);
    rotation.m11 = GLKVector3DotProduct(a.axes[1], b.axes[1]);
    rotation.m12 = GLKVector3DotProduct(a.axes[1], b.axes[2]);
    rotation.m20 = GLKVector3DotProduct(a.axes[2], b.axes[0]);
    rotation.m21 = GLKVector3DotProduct(a.axes[2], b.axes[1]);
    rotation.m22 = GLKVector3DotProduct(a.axes[2], b.axes[2]);
    
    GLKVector3 t = GLKVector3Subtract(b.center, a.center);
    t.v[0] = GLKVector3DotProduct(t, a.axes[0]);
    t.v[1] = GLKVector3DotProduct(t, a.axes[1]);
    t.v[2] = GLKVector3DotProduct(t, a.axes[2]);
    
    absRotation.m[0] = fabsf(rotation.m[0]) + FLT_EPSILON;
    absRotation.m[1] = fabsf(rotation.m[1]) + FLT_EPSILON;
    absRotation.m[2] = fabsf(rotation.m[2]) + FLT_EPSILON;
    absRotation.m[3] = fabsf(rotation.m[3]) + FLT_EPSILON;
    absRotation.m[4] = fabsf(rotation.m[4]) + FLT_EPSILON;
    absRotation.m[5] = fabsf(rotation.m[5]) + FLT_EPSILON;
    absRotation.m[6] = fabsf(rotation.m[6]) + FLT_EPSILON;
    absRotation.m[7] = fabsf(rotation.m[7]) + FLT_EPSILON;
    absRotation.m[8] = fabsf(rotation.m[8]) + FLT_EPSILON;
    
    ra = a.extent.v[0];
    rb = b.extent.v[0] * absRotation.m[0] + b.extent.v[1] * absRotation.m[1] + b.extent.v[2] * absRotation.m[2];
    if(fabsf(t.v[0]) > ra + rb) {
        return NO;
    }
    
    ra = a.extent.v[1];
    rb = b.extent.v[0] * absRotation.m[3] + b.extent.v[1] * absRotation.m[4] + b.extent.v[2] * absRotation.m[5];
    if(fabsf(t.v[1]) > ra + rb) {
        return NO;
    }
    
    ra = a.extent.v[2];
    rb = b.extent.v[0] * absRotation.m[6] + b.extent.v[1] * absRotation.m[7] + b.extent.v[2] * absRotation.m[8];
    if(fabsf(t.v[2]) > ra + rb) {
        return NO;
    }
    
    ra = a.extent.v[0] * absRotation.m[0] + a.extent.v[1] * absRotation.m[3] + a.extent.v[2] * absRotation.m[6];
    rb = a.extent.v[0];
    if(fabsf(t.v[0] * rotation.m[0] + t.v[1] * rotation.m[3] + t.v[2] * rotation.m[6]) > ra + rb) {
        return NO;
    }
    
    ra = a.extent.v[0] * absRotation.m[1] + a.extent.v[1] * absRotation.m[4] + a.extent.v[2] * absRotation.m[7];
    rb = a.extent.v[1];
    if(fabsf(t.v[0] * rotation.m[1] + t.v[1] * rotation.m[4] + t.v[2] * rotation.m[7]) > ra + rb) {
        return NO;
    }
    
    ra = a.extent.v[0] * absRotation.m[2] + a.extent.v[1] * absRotation.m[5] + a.extent.v[2] * absRotation.m[8];
    rb = a.extent.v[2];
    if(fabsf(t.v[0] * rotation.m[2] + t.v[1] * rotation.m[5] + t.v[2] * rotation.m[8]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A0 x B0
    ra = a.extent.v[1] * absRotation.m[6] + a.extent.v[2] * absRotation.m[3];
    rb = b.extent.v[1] * absRotation.m[2] + b.extent.v[2] * absRotation.m[1];
    if(fabsf(t.v[2] * rotation.m[3] - t.v[1] * rotation.m[6]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A0 x B1
    ra = a.extent.v[1] * absRotation.m[7] + a.extent.v[2] * absRotation.m[4];
    rb = b.extent.v[0] * absRotation.m[2] + b.extent.v[2] * absRotation.m[0];
    if(fabsf(t.v[2] * rotation.m[4] - t.v[1] * rotation.m[7]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A0 x B2
    ra = a.extent.v[1] * absRotation.m[8] + a.extent.v[2] * absRotation.m[3];
    rb = b.extent.v[0] * absRotation.m[1] + b.extent.v[1] * absRotation.m[0];
    if(fabsf(t.v[2] * rotation.m[5] - t.v[1] * rotation.m[8]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A1 x B0
    ra = a.extent.v[0] * absRotation.m[6] + a.extent.v[2] * absRotation.m[0];
    rb = b.extent.v[1] * absRotation.m[5] + b.extent.v[2] * absRotation.m[4];
    if(fabsf(t.v[0] * rotation.m[6] - t.v[2] * rotation.m[0]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A1 x B1
    ra = a.extent.v[0] * absRotation.m[7] + a.extent.v[2] * absRotation.m[1];
    rb = b.extent.v[0] * absRotation.m[5] + b.extent.v[2] * absRotation.m[3];
    if(fabsf(t.v[0] * rotation.m[7] - t.v[2] * rotation.m[1]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A1 x B2
    ra = a.extent.v[0] * absRotation.m[8] + a.extent.v[2] * absRotation.m[2];
    rb = b.extent.v[0] * absRotation.m[4] + b.extent.v[1] * absRotation.m[3];
    if(fabsf(t.v[0] * rotation.m[8] - t.v[2] * rotation.m[2]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A2 x B0
    ra = a.extent.v[0] * absRotation.m[3] + a.extent.v[2] * absRotation.m[0];
    rb = b.extent.v[1] * absRotation.m[8] + b.extent.v[2] * absRotation.m[7];
    if(fabsf(t.v[1] * rotation.m[0] - t.v[0] * rotation.m[3]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A2 x B1
    ra = a.extent.v[0] * absRotation.m[4] + a.extent.v[1] * absRotation.m[1];
    rb = b.extent.v[0] * absRotation.m[8] + b.extent.v[2] * absRotation.m[6];
    if(fabsf(t.v[1] * rotation.m[1] - t.v[0] * rotation.m[4]) > ra + rb) {
        return NO;
    }
    
    // test axis L = A2 x B2
    ra = a.extent.v[0] * absRotation.m[5] + a.extent.v[1] * absRotation.m[2];
    rb = b.extent.v[0] * absRotation.m[7] + b.extent.v[1] * absRotation.m[6];
    if(fabsf(t.v[1] * rotation.m[2] - t.v[0] * rotation.m[5]) > ra + rb) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)testRaySphere:(Ray *)ray sphere:(SphereBoundingVolume *)sphere {
    NSAssert(nil != ray || nil != sphere, @"Function PhysicsCollision/testRaySphere: argument nil");
    
    GLKVector3 m = GLKVector3Subtract(ray.origin, sphere.center);
    float c = GLKVector3DotProduct(m, m) - sphere.radius * sphere.radius;
    
    if(c <= 0.0f) {
        return YES;
    }
    
    float b = GLKVector3DotProduct(m, ray.direction);
    
    if(b > 0.0f) {
        return NO;
    }
    
    return b * b >= c;
}

+ (BOOL)intersectRaySphere:(Ray *)ray sphere:(SphereBoundingVolume *)sphere intersectPoint:(GLKVector3 *)intersection {
    NSAssert(nil != ray || nil != sphere, @"Function PhysicsCollision/intersectRaySphere: argument nil");
    
    GLKVector3 m = GLKVector3Subtract(ray.origin, sphere.center);
    float b = GLKVector3DotProduct(m, ray.direction);
    float c = GLKVector3DotProduct(m, m) - sphere.radius * sphere.radius;
    
    if(c > 0.0f && b > 0.0f) {
        return NO;
    }
    
    float discr = b * b - c;
    
    if(discr < 0.0f) {
        return NO;
    }
    
    if(nil == intersection) {
        return YES;
    }
    
    float t = -b - sqrtf(discr);
    
    if(t < 0.0f) {
        t = 0.0f;
    }
    
    *intersection = [ray pointAtLength:t];
    
    return YES;
}

+ (BOOL)intersectRayAABB:(Ray *)ray axisAlignedBoundingBox:(AxisAlignedBoundingBox *)aabb intersectPoint:(GLKVector3 *)intersection {
    NSAssert(nil != ray || nil != aabb, @"Function PhysicsCollision/intersectRayAABB: argument nil");
    
    float tmin = 0.0f;
    float tmax = FLT_MAX;
    
    for(int i = 0; i != 3; ++i) {
        if(fabsf(ray.direction.v[i]) < FLT_EPSILON) {
            if(ray.origin.v[i] < aabb.min.v[i] || ray.origin.v[i] > aabb.max.v[i]) {
                return NO;
            }
        } else {
            float ood = 1.0f/ray.direction.v[i];
            float t1 = (aabb.min.v[i] - ray.origin.v[i]) * ood;
            float t2 = (aabb.max.v[i] - ray.origin.v[i]) * ood;
            
            if(t1 > t2) {
                float t = t1;
                t1 = t2;
                t2 = t;
            }
            
            if(t1 > tmin) tmin = t1;
            if(t2 < tmax) tmax = t2;
            if(tmin > tmax) return NO;
        }
    }
    
    if(nil != intersection) {
        *intersection = [ray pointAtLength:tmin];
    }
    
    return YES;
}

+ (BOOL)intersectRayOBB:(Ray *)ray orientedBoundingBox:(OrientedBoundingBox *)obb intersectPoint:(GLKVector3 *)intersection {
    NSAssert(nil != ray || nil != obb, @"Function PhysicsCollision/intersectRayOBB: argument nil");
    
    GLKVector3 oc = GLKVector3Subtract(ray.origin, obb.center);
    GLKVector3 dc = GLKVector3Subtract(ray.direction, obb.center);
    
    oc.v[0] = GLKVector3DotProduct(oc, obb.axes[0]);
    oc.v[1] = GLKVector3DotProduct(oc, obb.axes[1]);
    oc.v[2] = GLKVector3DotProduct(oc, obb.axes[2]);
    
    dc.v[0] = GLKVector3DotProduct(dc, obb.axes[0]);
    dc.v[1] = GLKVector3DotProduct(dc, obb.axes[1]);
    dc.v[2] = GLKVector3DotProduct(dc, obb.axes[2]);
    
    Ray *obbRay = [Ray rayWithRay:oc direction:dc];
    
    float tmin = 0.0f;
    float tmax = FLT_MAX;
    
    for(int i = 0; i != 3; ++i) {
        float vmin = obb.center.v[i] - obb.extent.v[i];
        float vmax = obb.center.v[i] + obb.extent.v[i];
        
        if(fabsf(obbRay.direction.v[i]) < FLT_EPSILON) {
            if(obbRay.origin.v[i] < vmin || obbRay.origin.v[i] > vmax) {
                return NO;
            }
        } else {
            float ood = 1.0f/ray.direction.v[i];
            float t1 = (vmin - obbRay.origin.v[i]) * ood;
            float t2 = (vmax - obbRay.origin.v[i]) * ood;
            
            if(t1 > t2) {
                float t = t1;
                t1 = t2;
                t2 = t;
            }
            
            if(t1 > tmin) tmin = t1;
            if(t2 <
               tmax) tmax = t2;
            if(tmin > tmax) return NO;
        }
    }
    
    if(nil != intersection) {
        *intersection = [ray pointAtLength:tmin];
    }
    
    return YES;
}

@end
