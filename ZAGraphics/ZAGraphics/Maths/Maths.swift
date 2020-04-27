//
//  Maths.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

extension matrix_float4x4 {
    
    init(prespective fov: Float, aspecRatio: Float, near: Float, far: Float) {
        self.init()

        let y = 1 / tan(fov.radians() * 0.5)
        let x = y / aspecRatio
        let z = far / (near - far)
        let w = z * near
        
        columns = (
            simd_float4(x, 0, 0,  0),
            simd_float4(0, y, 0,  0),
            simd_float4(0, 0, z, -1),
            simd_float4(0, 0, w,  0)
        )
    }
    
    mutating func scale(axist: float3) {
        var scaleMatrix = matrix_identity_float4x4
        
        scaleMatrix.columns = (
            simd_float4(axist.x,    0,       0,       0),
            simd_float4(0,          axist.y, 0,       0),
            simd_float4(0,          0,       axist.z, 0),
            simd_float4(0,          0,       0,       1)
        )
        
        self = matrix_multiply(self, scaleMatrix)
    }
    
    mutating func translate(direction: float3) {
        var translateMatrix = matrix_identity_float4x4
        
        translateMatrix.columns = (
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, 0),
            simd_float4(direction.x, direction.y, direction.z, 1)
        )
        
        self = matrix_multiply(self, translateMatrix)
    }
    
    mutating func rotate(angle: Float, axist: float3) {
        var rotateMatrix = matrix_identity_float4x4
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        let mc: Float = 1 - c
        
        let x = axist.x
        let y = axist.y
        let z = axist.z
        
        rotateMatrix.columns = (
            simd_float4(x * x * mc + c,     x * y * mc + z * s, x * z * mc - y * s, 0),
            
            simd_float4(x * y * mc - z * s, y * y * mc + c,      y * z * mc + x * s, 0),
            
            simd_float4(x * z * mc + y * s, y * z * mc - x * s, z * z * mc + c, 0),
            
            simd_float4(0, 0, 0, 1)
        )
        
        self = matrix_multiply(self, rotateMatrix)
    }
}
