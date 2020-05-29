//
//  ZAOperation.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

/// Define style of operation can apply to texrture
/// Include filter, blend, effect, ...
enum ZAOperatorStyle {
    
    case None
    
    case Sketch
    
    case Inversion
    
    case Saturation
    
    case Contrast
    
    case Exposure
    
    case Crosshatch
    
    case AlphaBlend
    
    case LookupTable
    
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
            
        case .LookupTable:
            return ZAColorLookupTable()
            
        default:
            return ZAOperation()
        }
    }
}

//enum ZAOperationType {
//    /// Define type of Operator
//    /// One type can contains one styles
//
//    case Compute
//
//    case Blend
//}

public class ZAOperation {
    
    var vertexBuffer: MTLBuffer!
    
    var sampleState: MTLSamplerState!
    
    var vertexCount: Int = 0
    
    /// Renderable protocol
    var vertexName: String
    
    var fragmentName: String
    
    var texture: ZATexture!
    
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertexDes: MTLVertexDescriptor!
    
    /// Image source protocol
    public var consumers: [ImageConsumer]
    
    /// Image consumer protocol
    public var sources: [ZAWeakImageSource]
    
    /// Process texture by texture, don't allow proces 2 texture in same time
    /// Because we need check texture nil from all sources
    private let lock: DispatchSemaphore
    
    init(vertext: String = "basic_image_vertex", fragment: String = "basic_image_fragment") {
        
        vertexName = vertext
        fragmentName = fragment
        consumers = []
        sources = []
        lock = DispatchSemaphore(value: 1)
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
//    public func add(source: ImageSource) { }
//
//    public func remove(source: ImageSource) {  }
    
    // MARK: source
    public func newTextureAvailable(_ texture: ZATexture, from source: ImageSource) {
        
        lock.wait()
        /// Make sure all texture source available to draw, else wait next round
        for index in 0..<sources.count {
            if sources[index].source === source {
                sources[index].texture = texture.texture
            } else if sources[index].texture == nil {
                lock.signal()
                return
            }
        }

//        if sources[0].texture == nil || sources[1].texture == nil{
//            print("texture nil :)")
//        }
        self.texture = texture
        //print("size: ",MemoryLayout.size(ofValue: texture))
        self.draw()
    }
}

extension ZAOperation: Renderable {
    
    func draw() {
        guard let commanBuffer = sharedRenderer.commandQueue.makeCommandBuffer() else {
            return
        }
        
        /// Create new texture with info same input texture
        let outputTexture = ZATexture(device: sharedRenderer.device, texture: texture)
        
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
        //encoder.setFragmentTexture(texture.texture, index: 0)

        for index in 0..<sources.count {
            encoder.setFragmentTexture(sources[index].texture, index: index)
            sources[index].texture = nil
            print("index - ", index)
        }

        //encoder.setFragmentTexture(sources[0].texture, index: 0)
        lock.signal()
        updateParameters(for: encoder)

        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexCount, instanceCount: 1)
        encoder.endEncoding()

        commanBuffer.commit()
        commanBuffer.waitUntilCompleted()

        for consumer in consumers {
            consumer.newTextureAvailable(outputTexture, from: self)
        }
    }
}
