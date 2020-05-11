//
//  ZAOperation.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

/// Define style of operation
enum ZAOperatorStyle {
    
    case None
    
    case Sketch
    
    case Inversion
    
    case Saturation
    
    case Contrast
    
    case Exposure
    
    case Crosshatch
    
    case AlphaBlend
    
    func getOperation() -> ZAOperation {
        
        switch self {
        case .Sketch:
            return ZAColorSketch()
            
        case .Inversion:
            return ZAColorInversion()
            
        case .Saturation:
            return ZAColorSaturation()
            
        case .Contrast:
            return ZAColorContrast()
            
        case .Exposure:
            return ZAColorExposure()
            
        case .Crosshatch:
            return ZAEffectCrosshatch()
            
        case .AlphaBlend:
        return ZABlendOperation()
            
        case .None:
            return ZAOperation()
        }
    }
}

enum ZAOperationType {
    /// Define type of Operator
    /// One type can contains one styles
    
    case Compute
    
    case Blend
}

public class ZAOperation {
    
    var vertexBuffer: MTLBuffer!
    
    var sampleState: MTLSamplerState!
    
    var vertexCount: Int = 0
    
    //let textureSemaphone = DispatchSemaphore(value: 1)
    
    /// Renderable protocol
    var vertexName: String
    
    var fragmentName: String
    
    var texture: ZATexture!
    
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertexDes: MTLVertexDescriptor!
    
    // Image source protocol
    public var consumers: [ImageConsumer]
    
    init(vertext: String = "basic_image_vertex", fragment: String = "basic_image_fragment") {
        
        vertexName = vertext
        fragmentName = fragment
        consumers = []
    }
    
    func setup() {
        renderPipelineState = buildPipelineState(device: sharedRenderer.device)
        buildSampleState()
    }
    
    func buildSampleState() {
        let sampleStateDes = MTLSamplerDescriptor()
        sampleStateDes.minFilter = .linear
        sampleStateDes.magFilter = .linear
        sampleState = sharedRenderer.device.makeSamplerState(descriptor: sampleStateDes)
    }
    
    func updateParameters(for encoder: MTLRenderCommandEncoder) {
        /// This function should be overided by subclass
    }
}

extension ZAOperation: ImageSource, ImageConsumer {

    // MARK: consumer
    public func add(source: ImageSource) { }
    
    public func remove(source: ImageSource) {  }
    
    public func newTextureAvailable(_ texture: ZATexture, from source: ImageSource) {
//        let _ = textureSemaphone.wait(timeout:DispatchTime.distantFuture)
//        defer {
//            textureSemaphone.signal()
//        }
        self.texture = texture
        
        self.draw()
    }
}

extension ZAOperation: Renderable {
    
    func draw() {
        guard let commanBuffer = sharedRenderer.commandQueue.makeCommandBuffer() else {
            return
        }
        
        let outputTexture = ZATexture(device: sharedRenderer.device, width: texture.width(), height: texture.height())
        
        let renderPass = MTLRenderPassDescriptor()
        renderPass.colorAttachments[0].texture = outputTexture.texture
        renderPass.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1)
        renderPass.colorAttachments[0].storeAction = .store
        renderPass.colorAttachments[0].loadAction = .clear
        
        guard let encoder = commanBuffer.makeRenderCommandEncoder(descriptor: renderPass) else {
            return
        }
        encoder.setFragmentSamplerState(sampleState, index: 0)
        encoder.setRenderPipelineState(renderPipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setFragmentTexture(texture.texture, index: 0)
        
        updateParameters(for: encoder)
        
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexCount, instanceCount: 1)
        encoder.endEncoding()
        
        commanBuffer.commit()
        
        //textureSemaphone.signal()
        
        for consumer in consumers {
            consumer.newTextureAvailable(outputTexture, from: self)
        }
        
        //let _ = textureSemaphone.wait(timeout:DispatchTime.distantFuture)
    }
}
