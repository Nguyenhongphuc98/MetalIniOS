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

// Luminance Constants
constant half3 kLuminanceWeighting = half3(0.2125, 0.7154, 0.0721); // Values from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham

struct BasicVertexIn {
    float2 position [[attribute(0)]];
    float2 textCoords [[attribute(1)]];
};

struct BasicVertexOut {
    float4 position [[ position ]]; //float 4 la kieu cua position trog MSL
    float2 textCoords;
};

struct TwoInputVertexIn {
    float2 position [[attribute(0)]];
    float2 textCoords [[attribute(1)]];
    float2 textCoords2 [[attribute(2)]];
};

struct TwoInputVertexOut {
    float4 position [[ position ]]; //float 4 la kieu cua position trog MSL
    float2 textCoords;
    float2 textCoords2;
};

vertex BasicVertexOut basic_image_vertex(const BasicVertexIn vIn);

vertex TwoInputVertexOut two_image_vertex(const BasicVertexIn vIn);

float mod(float x, float y);
