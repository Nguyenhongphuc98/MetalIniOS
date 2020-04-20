//
//  Shader.metal
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
    float2 textCoords [[attribute(2)]];
};

struct VertexOut {
    float4 position [[ position ]]; //float 4 la kieu cua position trog MSL
    float4 color;
    float2 textCoords;
};

struct Constants {
    float animateBy;
};

struct ModelConstants {
    float4x4 modelMatrix;
};

struct SceneConstants {
    float4x4 projectionMatrix;
};

struct Light {
    float2 lightPos;
};

vertex VertexOut main_vertex(const VertexIn vIn [[stage_in]],
                             constant ModelConstants &modelConstants [[buffer(1)]],
                             constant SceneConstants &sceneConstants [[buffer(2)]]) {
    VertexOut v;
    v.position = sceneConstants.projectionMatrix * modelConstants.modelMatrix * float4(vIn.position, 1);
    v.color = vIn.color;
    v.textCoords = vIn.textCoords;
    return v;
}

fragment half4 main_fragment(VertexOut v [[stage_in]],
                              constant Light &light [[buffer(1)]]) {
    float intensity = 1 / length(v.position.xy - light.lightPos);
    float4 color = v.color * intensity * 1000;
    return half4(color.x, color.y, color.z, 1);
}

fragment half4 texture_fragment(VertexOut v [[stage_in]],
                              constant Light &light [[buffer(1)]],
                                sampler sample [[sampler(0)]],
                                texture2d<float> texture [[texture(0)]]) {
  
    float4 color = texture.sample(sample, v.textCoords);
  
    return half4(color.x, color.y, color.z, 1);
}
