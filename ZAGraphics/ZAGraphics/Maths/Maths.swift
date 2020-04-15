//
//  Maths.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

extension matrix_float4x4 {
    
    mutating func scale(axist: SIMD3<Float>) {
        var scaleMatrix = matrix_identity_float4x4
        
        scaleMatrix.columns = (
            simd_float4(axist.x, 0, 0, 0),
            simd_float4(0, axist.x, 0, 0),
            simd_float4(0, 0, axist.x, 0),
            simd_float4(0, 0, 0, 1)
        )
        
        self = matrix_multiply(self, scaleMatrix)
    }
}
