//
//  File.metal
//  ZAGraphics
//
//  Created by phucnh7 on 5/19/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
#include "../ZAOperation.h"

using namespace metal;

fragment half4 lookup_table_fragment(TwoInputVertexOut v [[stage_in]],
                                sampler sample [[sampler(0)]],
                                texture2d<float> texture1 [[texture(0)]],
                                texture2d<float> texture2 [[texture(1)]],
                                constant float &intentsity [[ buffer(2)]]) {
    
    half4 base = half4(texture1.sample(sample, v.textCoords));
    
    half blueColor = base.b * 63.0h;

    half2 quad1;
    quad1.y = floor(floor(blueColor) / 8.0h);
    quad1.x = floor(blueColor) - (quad1.y * 8.0h);

    half2 quad2;
    quad2.y = floor(ceil(blueColor) / 8.0h);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0h);

    const float A = 0.125;
    const float B = 0.5 / 512.0;
    const float C = 0.125 - 1.0 / 512.0;

    float2 texPos1;
    texPos1.x = A * quad1.x + B + C * base.r;
    texPos1.y = A * quad1.y + B + C * base.g;

    float2 texPos2;
    texPos2.x = A * quad2.x + B + C * base.r;
    texPos2.y = A * quad2.y + B + C * base.g;

    half4 newColor1 = half4(texture2.sample(sample, texPos1));
    half4 newColor2 = half4(texture2.sample(sample, texPos2));

    half4 newColor = mix(newColor1, newColor2, fract(blueColor));
    return half4(mix(newColor, half4(newColor.rgb, base.w), half(intentsity)));
}
