//
//  Shader.fsh
//  CrazyRubikCube
//
//  Created by xy on 05/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
