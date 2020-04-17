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
    
    var camera = Camera()
    
    var light = Light()
    
    init(device: MTLDevice) {
        super.init()
        sceneConstants.projectionMatrix = camera.projectionMatrix
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 2)
        commandEncoder.setFragmentBytes(&light, length: MemoryLayout<Light>.stride, index: 1)
        
        for child in children {
            child.render(commandEncoder: commandEncoder, parentMatrix: camera.viewMatrix)
        }
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, angle: Float) {
        
    }
}
