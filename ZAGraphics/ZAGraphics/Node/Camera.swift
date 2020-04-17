//
//  Camera.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/17/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Camera: Node {
    
    var fov: Float = 90
    
    var aspectRatio: Float = 1
    
    var near: Float = 0.1
    
    var far: Float = 100
    
    var viewMatrix: matrix_float4x4 {
        return modelMatrix
    }
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4.init(prespective: fov, aspecRatio: aspectRatio, near: near, far: far)
    }
}
