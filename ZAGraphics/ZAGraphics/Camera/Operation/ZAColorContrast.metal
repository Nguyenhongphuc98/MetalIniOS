//
//  ZAColorContrast.metal
//  ZAGraphics
//
//  Created by phucnh7 on 5/8/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
#include "ZAOperation.h"

using namespace metal;

fragment half4 contrast_fragment(ImageVertexOut vOut [[stage_in]],
                               sampler sample [[sampler(0)]],
                               texture2d<float> texture [[texture(0)]],
                               constant float &contrast [[ buffer(1)]]) {
    
    const float4 inColor = texture.sample(sample, vOut.textCoords);
    const half4 outColor(half3(inColor.rgb) - half3(0.5) * half3(contrast) + half3(0.5), inColor.a);

    return outColor;
}
