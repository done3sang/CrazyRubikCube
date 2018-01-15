//
//  Shader.fsh
//  CrazyRubikCube
//
//  Created by xy on 05/01/2017.
//  Copyright © 2017 SangDesu. All rights reserved.
//
precision lowp float;

uniform lowp mat4 woodSliceMatrix;
uniform lowp vec4 darkWoodColor;
uniform lowp vec4 lightWoodColor;
uniform sampler2D noiseTexture;

varying lowp vec3 v_normal;
varying lowp vec2 v_texCoord0;

lowp float graphScope = 0.4;
lowp float graphOver = 0.41;
lowp float graphTake = 0.01;
lowp float anchor = 0.5;

lowp vec4 woodGrainEffect(in lowp vec2 texCoord) {
    mediump vec4 cyl = woodSliceMatrix * vec4(texCoord.st, 0.0, 1.0);
    mediump float dist = length(cyl.xz);
    //mediump vec4 noise = texture2D(noiseTexture, texCoord);
    //dist += noise.b * 2.5;
    mediump float t = 1.0 - abs(fract(dist) * 2.0 - 1.0);
    t = smoothstep(0.2, 0.5, t);
    return mix(darkWoodColor, lightWoodColor, t);
}

lowp float circleEncroach(in lowp vec2 texCoord) {
    lowp float t = distance(texCoord, vec2(anchor));
    t = smoothstep(graphScope, graphOver, t);
    
    return t;
}

lowp float triangleEncroach(in lowp vec2 texCoord) {
    mediump vec2 a = vec2(0.5, 0.9);
    mediump vec2 b = vec2(0.15359, 0.3);
    mediump vec2 c = vec2(0.84641, 0.3);
    mediump vec2 pa = a - texCoord;
    mediump vec2 pb = b - texCoord;
    mediump vec2 pc = c - texCoord;
    mediump float ab = dot(pa, pb);
    mediump float ac = dot(pa, pc);
    mediump float bc = dot(pb, pc);
    mediump float cc = dot(pc, pc);
    
    mediump float v1 = 0.0;
    v1 = bc * ac - cc * ab;
    if(v1 < 0.0) {
        return 1.0;
    }
    
    mediump float bb = dot(pb, pb);
    mediump float v2 = ab * bc - ac * bb;
    if(v2 < 0.0) {
        return 1.0;
    }
    
    return v1 * v2;
}

lowp float squareEncroach(in lowp vec2 texCoord) {
    lowp vec2 dt = abs(texCoord - vec2(anchor));
    
    dt = smoothstep(vec2(0.3), vec2(0.35), dt);
    
    return clamp(dot(dt, dt), 0.0, 1.0);
}

// r=0.3-0.3sinθ
lowp float cardioidsEncroach(in lowp vec2 texCoord) {
    lowp float f = 0.3;
    lowp vec2 t = texCoord - vec2(anchor, anchor + f);
    lowp float len = length(t);
    lowp float r = f - f * t.y/len;
    
    return smoothstep(r, r + graphTake, len);
}

// r=sqrt(0.2cos2θ)
lowp float lemniscatesEncroach(in lowp vec2 texCoord) {
    lowp vec2 t = texCoord - vec2(anchor);
    lowp float sql = dot(t, t);
    lowp float cosine2 = 2.0 * t.x * t.x/sql - 1.0;
    lowp float r = 0.2 * cosine2;
    
    return smoothstep(r, r + graphTake, sql);
}

// r=0.2cos2θ
lowp float roseEncroach(in lowp vec2 texCoord) {
    lowp vec2 t = texCoord - vec2(anchor);
    lowp float sql = dot(t, t);
    lowp float cosine2 = 2.0 * t.x * t.x/sql - 1.0;
    lowp float r = graphScope * cosine2;
    
    r *= r;
    return smoothstep(r, r + graphTake, sql);
}

void main() {
    lowp vec4 woodColor = woodGrainEffect(v_texCoord0);
    lowp float patternRate = roseEncroach(v_texCoord0);
    lowp vec4 patternColor = vec4(1.0, 0.0, 0.0, 1.0);
    
    gl_FragColor = mix(patternColor, woodColor, patternRate);
}
 
