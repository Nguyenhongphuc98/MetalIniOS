//
//  ZAColorSketch.metal
//  ZAGraphics
//
//  Created by phucnh7 on 4/27/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
#include "ZAOperation.h"

using namespace metal;

fragment half4 sketch_fragment(ImageVertexOut vOut [[stage_in]],
                               sampler sample [[sampler(0)]],
                               texture2d<float> texture [[texture(0)]]) {
    
    const float x = vOut.position.x;
    const float y = vOut.position.y;
    const float width = texture.get_width();
    const float height = texture.get_width();
    
    if (x >= width || y >= height )
        return half4(1, 1, 1, 1);
    
    const float2 leftCoordinate = float2((x - 1) / width, y / height);
    const float2 rightCoordinate = float2((x + 1) / width, y / height);
    const float2 topCoordinate = float2(x / width, (y - 1) / height);
    const float2 bottomCoordinate = float2(x / width, (y + 1) / height);
    const float2 topLeftCoordinate = float2((x - 1) / width, (y - 1) / height);
    const float2 topRightCoordinate = float2((x + 1) / width, (y - 1) / height);
    const float2 bottomLeftCoordinate = float2((x - 1) / width, (y + 1) / height);
    const float2 bottomRightCoordinate = float2((x + 1) / width, (y + 1) / height);
    
    const half leftIntensity = texture.sample(sample, leftCoordinate).r;
    const half rightIntensity = texture.sample(sample, rightCoordinate).r;
    const half topIntensity = texture.sample(sample, topCoordinate).r;
    const half bottomIntensity = texture.sample(sample, bottomCoordinate).r;
    const half topLeftIntensity = texture.sample(sample, topLeftCoordinate).r;
    const half topRightIntensity = texture.sample(sample, topRightCoordinate).r;
    const half bottomLeftIntensity = texture.sample(sample, bottomLeftCoordinate).r;
    const half bottomRightIntensity = texture.sample(sample, bottomRightCoordinate).r;
    
    const half h = -topLeftIntensity - 2.0h * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0h * bottomIntensity + bottomRightIntensity;
    const half v = -bottomLeftIntensity - 2.0h * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0h * rightIntensity + topRightIntensity;
    
    const half mag = 1.0h - (length(half2(h, v)) * float(2));
    const half4 outColor(half3(mag), 1.0h);
    return outColor;
}

