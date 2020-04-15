//
//  Scene.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Scene: Node {
    
    var sceneConstants = SceneConstants()
    
    init(device: MTLDevice) {
        super.init()
        sceneConstants.projectionMatrix = matrix_float4x4.init(prespective: 45, aspecRatio: 1, near: 0.1, far: 100)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 2)
        super.render(commandEncoder: commandEncoder)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, angle: Float) {
        
    }
}
