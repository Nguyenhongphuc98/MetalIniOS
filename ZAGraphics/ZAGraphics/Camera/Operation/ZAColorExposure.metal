//
//  ZAColorExposure.metal
//  ZAGraphics
//
//  Created by phucnh7 on 5/8/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
#include "ZAOperation.h"

using namespace metal;

fragment half4 exposure_fragment(BasicVertexOut vOut [[stage_in]],
                               sampler sample [[sampler(0)]],
                               texture2d<float> texture [[texture(0)]],
                               constant float &exposure [[ buffer(1)]]) {
    
    const float4 inColor = texture.sample(sample, vOut.textCoords);
    const half4 outColor(half3(inColor.rgb) * half3(pow(2.0, exposure)), inColor.a);

    return outColor;
}
