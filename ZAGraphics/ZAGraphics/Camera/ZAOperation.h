//
//  ZAOperation.h
//  ZAGraphics
//
//  Created by phucnh7 on 4/29/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#ifndef ZAOperation_h
#define ZAOperation_h


#endif /* ZAOperation_h */

struct ImageVertexIn {
    float2 position [[attribute(0)]];
    float2 textCoords [[attribute(1)]];
};

struct ImageVertexOut {
    float4 position [[ position ]]; //float 4 la kieu cua position trog MSL
    float2 textCoords;
};

vertex ImageVertexOut basic_image_vertex(const ImageVertexIn vIn [[stage_in]]);
