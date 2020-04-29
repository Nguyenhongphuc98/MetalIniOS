//
//  Renderer.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    
    /**
        dung de render bat cu thu gi, goi draw trong render function
        */
    
    public static var device: MTLDevice = MTLCreateSystemDefaultDevice() as! MTLDevice
    
    var commandQueue: MTLCommandQueue!
    
    var sampleState: MTLSamplerState!
    
    var availableTexture: AvailableTexture?
    
    /// using for game engine
    var scene: Scene!
    
    var depthStencilState: MTLDepthStencilState!
    
    var wireFrameOn: Bool = false
    
    var mousePosition = float2(0, 0)
    
    override init() {
        super.init()
        
        commandQueue = Renderer.device.makeCommandQueue()
        //scene = BasicScene(device: d)
        //buildDepthStencilState(device: device)
        buildSampleState(device: Renderer.device)
    }
    
    func buildDepthStencilState(device: MTLDevice){
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
    func buildSampleState(device: MTLDevice) {
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
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func newTextureAvailable(_ texture: ZATexture, from source: ImageSource, for view: MTKView) {
        self.availableTexture = AvailableTexture(texture: texture, source: source, view: view)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let renderPassDes = view.currentRenderPassDescriptor,
            let newTexture = self.availableTexture else {
                return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDes)
        //commandEncoder!.setDepthStencilState(depthStencilState)
        commandEncoder?.setFragmentSamplerState(sampleState, index: 0)
        
        
        if let s = newTexture.source as? ZAOperaion {
            s.draw(commandEncoder: commandEncoder!)
        }
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
        
//        guard let drawable = view.currentDrawable,
//            let renderPassDes = view.currentRenderPassDescriptor else {
//                return
//        }
//
//        let commandBuffer = commandQueue.makeCommandBuffer()
//        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDes)
//        //commandEncoder!.setDepthStencilState(depthStencilState)
//        commandEncoder?.setFragmentSamplerState(sampleState, index: 0)
//
//        if wireFrameOn {
//            commandEncoder?.setTriangleFillMode(.lines)
//        }
//
//        ///render scene in 3D space
//        //scene.light.lightPos = mousePosition
//
//        //let delta = 1 / Float(view.preferredFramesPerSecond)
//        //scene.render(commandEncoder: commandEncoder!, angle: delta)
//
//        //render image
//        //sharedInversion.draw(commandEncoder: commandEncoder!, modelViewMatrix: matrix_float4x4.init())
//        sharedSketch.draw(commandEncoder: commandEncoder!)
//        commandEncoder?.endEncoding()
//        commandBuffer?.present(drawable)
//        commandBuffer?.commit()
    }
}


struct AvailableTexture {
    var texture: ZATexture
    var source: ImageSource
    var view: MTKView
}
