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

vertex ImageVertexOut basic_image_vertex(const ImageVertexIn vIn [[stage_in]]) {
    ImageVertexOut v;
    v.textCoords = vIn.textCoords;
    v.position = float4(vIn.position, 0, 1);
    return v;
}

fragment half4 basic_image_fragment(ImageVertexOut v [[stage_in]],
                                sampler sample [[sampler(0)]],
                                texture2d<float> texture [[texture(0)]]) {
    
    float4 color = texture.sample(sample, v.textCoords);
    
    return half4(color.x, color.y, color.z, 1);
}

float mod(float x, float y) {
    return x - y * floor(x / y);
}
