//
//  Types.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

struct Vertex {
    /// Define a common vertext for render model
    
    var position: float3
    
    var color: float4
    
    var textCoords: float2
}

/// Constant pass to vertex function
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
struct BasicVertex {
    
    var position: float2
    
    var textCoords: float2
}

struct TwoInputVertex {
    
    var position: float2
    
    var textCoords1: float2
    
    var textCoords2: float2
}
