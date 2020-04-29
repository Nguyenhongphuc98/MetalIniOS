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

