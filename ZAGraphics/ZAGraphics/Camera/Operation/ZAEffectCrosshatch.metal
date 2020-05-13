//
//  ZAEffectCrosshatch.metal
//  ZAGraphics
//
//  Created by phucnh7 on 5/8/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
#include "ZAOperation.h"

using namespace metal;

fragment half4 crosshatch_fragment(BasicVertexOut vOut [[stage_in]],
                               sampler sample [[sampler(0)]],
                               texture2d<float> texture [[texture(0)]],
                               constant float &crosshatchSpace [[ buffer(1)]],
                               constant float &lineWidth [[ buffer(2)]]) {
    
    const float x = vOut.textCoords.x;
    const float y = vOut.textCoords.y;
    
    const float4 color = texture.sample(sample, vOut.textCoords);
    const half luminance = dot(half3(color.rgb), kLuminanceWeighting);
    
    const bool isBlackColor = (luminance < 1 && mod(x + y, crosshatchSpace) <= lineWidth)
                            || (luminance < 0.75 && mod(x - y, crosshatchSpace) <= lineWidth)
                            || (luminance < 0.5 && mod(x + y - crosshatchSpace / 2, crosshatchSpace) <= lineWidth)
                            || (luminance <0.3 && mod(x - y - crosshatchSpace / 2, crosshatchSpace) <= lineWidth);

    const half4 outColor = isBlackColor ? half4(0.0, 0.0, 0.0, 1.0) : half4(1.0);
    return outColor;
}
