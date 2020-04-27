//
//  ZAColorInversion.metal
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ImageVertexIn {
    float2 position [[attribute(0)]];
    float2 textCoords [[attribute(1)]];
};

struct ImageVertexOut {
    float4 position [[ position ]]; //float 4 la kieu cua position trog MSL
    float2 textCoords;
};

vertex ImageVertexOut inversion_vertex(const ImageVertexIn vIn [[stage_in]]) {
    ImageVertexOut v;
    v.textCoords = vIn.textCoords;
    v.position = float4(vIn.position, 0, 1);
    return v;
}

fragment half4 inversion_fragment(ImageVertexOut v [[stage_in]],
                                sampler sample [[sampler(0)]],
                                texture2d<float> texture [[texture(0)]]) {
    
    float4 color = texture.sample(sample, v.textCoords);
    
    return half4(1 - color.x, 1 - color.y, 1 - color.z, 1);
}
