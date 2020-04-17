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
    
    var depthStencilState: MTLDepthStencilState!
    
    var wireFrameOn: Bool = false
    
    var mousePosition = SIMD2<Float>(0, 0)
    
    init(device: MTLDevice) {
        self.device = device
        super.init()
        
        commandQueue = device.makeCommandQueue()
        scene = BasicScene(device: device)
        //buildDepthStencilState(device: device)
    }
    
    func buildDepthStencilState(device: MTLDevice){
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
    func toggleWireFrame(isOn: Bool) {
        wireFrameOn = isOn
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
        //commandEncoder!.setDepthStencilState(depthStencilState)
        if wireFrameOn {
            commandEncoder?.setTriangleFillMode(.lines)
        }
        
        scene.light.lightPos = mousePosition
        
        let delta = 1 / Float(view.preferredFramesPerSecond)
        scene.render(commandEncoder: commandEncoder!, angle: delta)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
