//
//  ZAColorSaturation.metal
//  ZAGraphics
//
//  Created by phucnh7 on 5/4/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
#include "../ZAOperation.h"

using namespace metal;

fragment half4 saturation_fragment(BasicVertexOut vOut [[stage_in]],
                               sampler sample [[sampler(0)]],
                               texture2d<float> texture [[texture(0)]],
                               constant float &saturation [[ buffer(1)]]) {
    
    const float4 inColor = texture.sample(sample, vOut.textCoords);
    const half luminance = dot(inColor.rgb, float3(kLuminanceWeighting));
    const half4 outColor(mix(half3(luminance), half3(inColor.rgb), half(saturation)),inColor.a);

    return outColor;
}
