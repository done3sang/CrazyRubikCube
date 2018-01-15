//
//  Ray.h
//  CrazyRubikCube
//
//  Created by xy on 07/02/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Ray : NSObject {
    GLKVector3 _origin;
    GLKVector3 _direction;
}

@property (nonatomic, assign) GLKVector3 origin;
@property (nonatomic, assign) GLKVector3 direction;

- (instancetype)initWithRay:(GLKVector3)origin direction:(GLKVector3)direction;

+ (Ray*)rayWithRay:(GLKVector3)origin direction:(GLKVector3)direction;

- (GLKVector3)pointAtLength:(float)t;

@end
