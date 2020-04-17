//
//  Node.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Node {
    
    var device: MTLDevice!
    
    var children: [Node] = []
    
    var position = SIMD3<Float>(repeating: 0)
    
    var rotation = SIMD3<Float>(repeating: 0)
    
    var scale = SIMD3<Float>(repeating: 1)
    
    var modelMatrix: matrix_float4x4 {
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction: position)
        modelMatrix.rotate(angle: rotation.x, axist: SIMD3<Float>(1, 0, 0))
        modelMatrix.rotate(angle: rotation.y, axist: SIMD3<Float>(0, 1, 0))
        modelMatrix.rotate(angle: rotation.z, axist: SIMD3<Float>(0, 0, 1))
        modelMatrix.scale(axist: scale)
        return modelMatrix
    }
    
    func add(child: Node) {
        children.append(child)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, parentMatrix: matrix_float4x4) {
        for child in children {
            child.render(commandEncoder: commandEncoder, parentMatrix: parentMatrix)
        }
        
        let modelViewMatrix: matrix_float4x4 = matrix_multiply(parentMatrix, modelMatrix)
        
        if let c = self as? Renderable {
            c.draw(commandEncoder: commandEncoder, modelViewMatrix: modelViewMatrix)
        }
    }
}
