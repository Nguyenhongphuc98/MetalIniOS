//
//  ZAEffectVideoMask.metal
//  ZAGraphics
//
//  Created by phucnh7 on 5/29/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
#include "../ZAOperation.h"

using namespace metal;

// alpha blend frangment
fragment half4 videomask_fragment(TwoInputVertexOut v [[stage_in]],
                                sampler sample [[sampler(0)]],
                                texture2d<float> texture1 [[texture(0)]],
                                texture2d<float> texture2 [[texture(1)]]) {
    
    float4 color1 = texture1.sample(sample, v.textCoords);
    float4 color2 = texture2.sample(sample, v.textCoords2);
    return half4(mix(half3(color1.rgb), half3(color2.rgb), color2.a * half(0.5)), color2.a);
}
