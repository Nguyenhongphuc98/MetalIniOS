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
    
    var renderPipelineState: MTLRenderPipelineState!
    
    var commandQueue: MTLCommandQueue!
    
    init(device: MTLDevice) {
        self.device = device
        super.init()
        
        commandQueue = device.makeCommandQueue()
        setupPipeline()
    }
    
    func setupCommandQueue() {
        commandQueue = device.makeCommandQueue()
    }
    
    func setupPipeline() {
        let lib = device.makeDefaultLibrary()
        let vertexFunction = lib?.makeFunction(name: "main_vertex")
        let fragmentFunction = lib?.makeFunction(name: "main_fragment")
        let renderPipelineDes = MTLRenderPipelineDescriptor()
        
        renderPipelineDes.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDes.vertexFunction = vertexFunction
        renderPipelineDes.fragmentFunction = fragmentFunction
        
        do {
            try renderPipelineState = device.makeRenderPipelineState(descriptor: renderPipelineDes)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
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
        
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
