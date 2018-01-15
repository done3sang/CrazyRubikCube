//
//  RubikTypes.h
//  CrazyRubikCube
//
//  Created by xy on 20/06/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

#ifndef RubikTypes_h
#define RubikTypes_h

typedef enum _RubikBlockOrientation {
    RubikBlockOrientationNone,
    RubikBlockOrientationHorizontal,
    RubikBlockOrientationVertical
} RubikBlockOrientation;

typedef enum _RubikTouchOrientation {
    TouchOrientationNone,
    TouchOrientationUp,
    TouchOrientationDown,
    TouchOrientationLeft,
    TouchOrientationRight
} RubikTouchOrientation;

typedef enum _RubikTouchFace {
    TouchFaceNone,
    TouchFaceUp,
    TouchFaceBottom,
    TouchFaceLeft,
    TouchFaceRight,
    TouchFaceFront,
    TouchFaceBack
} RubikTouchFace;

#endif /* RubikTypes_h */
