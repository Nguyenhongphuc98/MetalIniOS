//
//  Renderer.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

struct AvailableTexture {
    var texture: ZATexture
    var source: ImageSource
    var view: MTKView
}

public let sharedRenderer = Renderer()

public class Renderer: NSObject {
    
    /**
        Using for render anything
    */
    
    /// Device using for all work relative to render
    public var device: MTLDevice = MTLCreateSystemDefaultDevice()!
    
    public var commandQueue: MTLCommandQueue!
    
    var sampleState: MTLSamplerState!
    
    /// Using for game engine
    var scene: Scene!
    
    var depthStencilState: MTLDepthStencilState!
    
    var wireFrameOn: Bool = false
    
    var mousePosition = float2(0, 0)
    
    override init() {
        super.init()
        
        commandQueue = device.makeCommandQueue()
        //scene = BasicScene(device: d)
        //buildDepthStencilState(device: device)
        buildSampleState()
    }
    
    func buildDepthStencilState(device: MTLDevice){
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
    func buildSampleState() {
        let sampleStateDes = MTLSamplerDescriptor()
        sampleStateDes.minFilter = .linear
        sampleStateDes.magFilter = .linear
        sampleState = device.makeSamplerState(descriptor: sampleStateDes)
    }
    
    func toggleWireFrame(isOn: Bool) {
        wireFrameOn = isOn
    }
}

extension Renderer: MTKViewDelegate {
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    public func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let renderPassDes = view.currentRenderPassDescriptor else {
                return
        }
        
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDes)
        //commandEncoder!.setDepthStencilState(depthStencilState)
        commandEncoder?.setFragmentSamplerState(sampleState, index: 0)
        
        /// Actualy, this space should be let model (2-3D) render by it self
        /// Start draw all model in this scence
        
//        if let s = newTexture.source as? ZAOperaion {
//            s.draw(commandEncoder: commandEncoder!)
//        }
        
      
        /// End draw by each model
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
