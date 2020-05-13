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

extension matrix_float3x3 {
    
    mutating func translate(direction: float2) {
        var translateMatrix = matrix_identity_float3x3
        
        translateMatrix.columns = (
            simd_float3(1, 0, 0),
            simd_float3(0, 1, 0),
            simd_float3(direction.x, direction.y, 1)
        )
        
        self = matrix_multiply(self, translateMatrix)
    }
}


extension CGRect {
    
    mutating func gotoCenter() -> (CGFloat, CGFloat){
        
        let dx = self.origin.x + self.size.width / 2
        let dy = self.origin.y + self.size.height / 2
        
        self.translate(x: -dx, y: -dy)
        
        return (dx, dy)
    }
    
    mutating func translate(x: CGFloat, y: CGFloat) {
        self.origin.x += x
        self.origin.y += y
    }
    
    mutating func scale(sx: CGFloat, sy: CGFloat) {
        
        let (dx, dy) = self.gotoCenter()
        
        self.origin.x *= sx
        self.origin.y *= sy
        self.size.width *= sx
        self.size.height *= sy
        
        self.translate(x: dx, y: dy)
    }
    
    
    /// This function just rotate correct for texture coordinates space
    mutating func rotate(angle alpha: CGFloat) -> (CGPoint, CGPoint, CGPoint, CGPoint) {
        
        /// We need bring it to O(0,0) and rotate it, if no - rotate not exactly what we expected
        /// Because just get return value so we don't return origin coords
        /// If want to using this CGRect again, this function not ok
        self.translate(x: -0.5, y: -0.5)
        let tl = CGPoint(x: self.origin.x * cos(alpha) - self.origin.y * sin(alpha) + 0.5,
                         y: self.origin.x * sin(alpha) + self.origin.y * cos(alpha) + 0.5)
        let bl = CGPoint(x: self.origin.x * cos(alpha) - (self.origin.y + self.size.height) * sin(alpha) + 0.5,
                         y: self.origin.x * sin(alpha) + (self.origin.y + self.size.height) * cos(alpha) + 0.5)
        let br = CGPoint(x: (self.origin.x + self.size.width) * cos(alpha) - (self.origin.y + self.size.height) * sin(alpha) + 0.5,
                         y: (self.origin.x + self.size.width) * sin(alpha) + (self.origin.y + self.size.height) * cos(alpha) + 0.5)
        let tr = CGPoint(x: (self.origin.x + self.size.width) * cos(alpha) - self.origin.y * sin(alpha) + 0.5,
                         y: (self.origin.x + self.size.width) * sin(alpha) + self.origin.y * cos(alpha) + 0.5)
        
        return (tl, bl, br, tr)
    }
}


extension CGFloat {
    
    func toRadian() -> CGFloat {
        self * .pi / 180
    }
    
    func toDegrees() -> CGFloat {
        self * 180 / .pi
    }
}
