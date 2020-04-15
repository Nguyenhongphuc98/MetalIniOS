//
//  Types.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

struct Constants {
    var anmateBy: Float = 0.0
}

struct ModelConstants {
    var modelMatrix = matrix_identity_float4x4
}
