//
//  PreviewMetalView.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/6/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class PreviewMetalView: MTKView {
    
    /// Renderable protocol
    var vertexName: String = "basic_image_vertex"
    
    var fragmentName: String = "basic_image_fragment"
    
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertexDes: MTLVertexDescriptor {
        let vertexDes = MTLVertexDescriptor()
        vertexDes.attributes[0].bufferIndex = 0
        vertexDes.attributes[0].format = .float2
        vertexDes.attributes[0].offset = 0
        
        vertexDes.attributes[1].bufferIndex = 0
        vertexDes.attributes[1].format = .float2
        vertexDes.attributes[1].offset = MemoryLayout<float2>.size
        
        vertexDes.layouts[0].stride = MemoryLayout<BasicVertex>.stride
        return vertexDes
    }
    
    /// properties
    var availableTexture: ZATexture?
    
    var sampleState: MTLSamplerState!
    
    var verties: [BasicVertex]!
    
    var vertexBuffer: MTLBuffer!
    
    //Using for take photo
    public var captureTexture: ZATexture!

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, device: sharedRenderer.device)
        setup()
    }
    
    func setup() {
        colorPixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(red: 0, green:0, blue: 0, alpha: 1)
        
        verties = defaulfBasicVerties()
        vertexBuffer = sharedRenderer.device.makeBuffer(bytes: verties,
                                                        length: verties.count * MemoryLayout.stride(ofValue: verties[0]),
                                                        options: [])
        renderPipelineState = buildPipelineState(device: sharedRenderer.device)
        buildSampleState()
    }
    
    func buildSampleState() {
        let sampleStateDes = MTLSamplerDescriptor()
        sampleStateDes.minFilter = .linear
        sampleStateDes.magFilter = .linear
        sampleState = sharedRenderer.device.makeSamplerState(descriptor: sampleStateDes)
    }
    
    override func draw(_ rect: CGRect)  {
        guard let drawable = currentDrawable,
            let renderPassDes = currentRenderPassDescriptor,
            let newTexture = self.availableTexture else {
                return
        }
        self.captureTexture = availableTexture
        self.availableTexture = nil
        
        let commandBuffer = sharedRenderer.commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDes)
        commandEncoder?.setFragmentSamplerState(sampleState, index: 0)
        
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.setFragmentTexture(newTexture.texture, index: 0)
        
        commandEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: verties.count, instanceCount: 1)
        commandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

extension PreviewMetalView: ImageConsumer {
    func add(source: ImageSource) { }
    
    func remove(source: ImageSource) { }
    
    func newTextureAvailable(_ texture: ZATexture, from source: ImageSource) {
        availableTexture = texture
        //print("new texture available")
        //self.draw()
    }
}

extension PreviewMetalView: Renderable {
}
