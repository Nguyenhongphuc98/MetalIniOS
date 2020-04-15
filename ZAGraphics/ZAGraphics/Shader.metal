//
//  Shader.metal
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[ position ]]; //float 4 la kieu cua position trog MSL
    float4 color;
};

struct Constants {
    float animateBy;
};

struct ModelConstants {
    float4x4 modelMatrix;
};

vertex VertexOut main_vertex(const VertexIn vIn [[stage_in]],
                             constant ModelConstants &modelConstants [[buffer(1)]]) {
    VertexOut v;
    v.position = modelConstants.modelMatrix * float4(vIn.position, 1);
    v.color = vIn.color;
    return v;
}

fragment float4 main_fragment(VertexOut v [[stage_in]]) {
    return v.color;
}
