//
//  Shader.vsh
//  CrazyRubikCube
//
//  Created by xy on 05/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//

attribute vec4 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord0;

uniform mat4 u_mvpMatrix;
uniform mat3 u_normalMatrix;

varying vec3 v_normal;
varying vec2 v_texCoord0;

void main() {
    v_normal = a_normal;
    v_texCoord0 = a_texCoord0;
    
    gl_Position = u_mvpMatrix * a_position;
}
