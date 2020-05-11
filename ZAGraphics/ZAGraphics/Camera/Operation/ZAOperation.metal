//
//  ZAOperation.metal
//  ZAGraphics
//
//  Created by phucnh7 on 4/29/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include "ZAOperation.h"

// Math function
float mod(float x, float y) {
    return x - y * floor(x / y);
}


// Basic shader function
vertex BasicVertexOut basic_image_vertex(const BasicVertexIn vIn [[stage_in]]) {
    BasicVertexOut v;
    v.textCoords = vIn.textCoords;
    v.position = float4(vIn.position, 0, 1);
    return v;
}

fragment half4 basic_image_fragment(BasicVertexOut v [[stage_in]],
                                sampler sample [[sampler(0)]],
                                texture2d<float> texture [[texture(0)]]) {
    
    float4 color = texture.sample(sample, v.textCoords);
    
    return half4(color.x, color.y, color.z, 1);
}

vertex TwoInputVertexOut two_image_vertex(const TwoInputVertexIn vIn [[stage_in]]) {
    TwoInputVertexOut v;
    v.position = float4(vIn.position, 0, 1);
    v.textCoords = vIn.textCoords;
    v.textCoords2 = vIn.textCoords2;
    return v;
}

// alpha blend frangment
fragment half4 two_image_fragment(TwoInputVertexOut v [[stage_in]],
                                sampler sample [[sampler(0)]],
                                texture2d<float> texture1 [[texture(0)]],
                                texture2d<float> texture2 [[texture(1)]]) {
    
    float4 color1 = texture1.sample(sample, v.textCoords);
    float4 color2 = texture2.sample(sample, v.textCoords2);
    
    return half4(mix(half3(color1.rgb), half3(color2.rgb), color2.a * half(1.0)), color2.a);
}
