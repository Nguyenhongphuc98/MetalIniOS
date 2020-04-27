//
//  Types.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

struct Vertex {
    var position: float3
    var color: float4
    var textCoords: float2
}

struct Constants {
    var anmateBy: Float = 0.0
}

struct ModelConstants {
    var modelMatrix = matrix_identity_float4x4
}

struct SceneConstants {
    var projectionMatrix = matrix_identity_float4x4
}

struct Light {
    var lightPos = float2(0)
}


///process image
struct ImageVertex {
    var position: float2
    var textCoords: float2
}
