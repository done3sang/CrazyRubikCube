//
//  GeometryMaker.h
//  CrazyRubikCube
//
//  Created by xy on 23/12/2016.
//  Copyright © 2016 SangDesu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GeometryMesh;

@interface GeometryMaker : NSObject {
    NSMutableDictionary *_meshDict;
}

+ (GeometryMaker*)sharedGeometryMaker;

- (GeometryMesh*)geometryMeshByName:(NSString*)meshName;

@end
