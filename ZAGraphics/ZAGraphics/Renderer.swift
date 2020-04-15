//
//  Renderer.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    
    var device: MTLDevice!
    
    var commandQueue: MTLCommandQueue!
    
    var scene: Scene!
    
    init(device: MTLDevice) {
        self.device = device
        super.init()
        
        commandQueue = device.makeCommandQueue()
        scene = BasicScene(device: device)
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let renderPassDes = view.currentRenderPassDescriptor else {
                return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDes)
        
        scene.render(commandEncoder: commandEncoder!)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
