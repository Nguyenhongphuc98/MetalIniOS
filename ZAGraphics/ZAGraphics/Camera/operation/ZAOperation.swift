//
//  ZAOperation.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

enum ZAOperatorType {
    
    case FilterNone
    
    case FilterSketch
    
    case FilterInversion
    
    case FilterSaturation
    
    func getOperation() -> ZAOperaion {
        switch self {
            
        case .FilterSketch:
            return ZAColorSketch()
            
        case .FilterInversion:
            return ZAColorInversion()
            
        case .FilterSaturation:
            return ZAColorSaturation()
            
        default:
            return ZAOperaion()
        }
    }
}

class ZAOperaion {
    
    var verties: [ImageVertex]!
    
    var vertexBuffer: MTLBuffer!
    
    /// Renderable protocol
    var vertexName: String
    
    var fragmentName: String
    
    var texture: ZATexture!
    
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertexDes: MTLVertexDescriptor {
        let vertexDes = MTLVertexDescriptor()
        vertexDes.attributes[0].bufferIndex = 0
        vertexDes.attributes[0].format = .float2
        vertexDes.attributes[0].offset = 0
        
        vertexDes.attributes[1].bufferIndex = 0
        vertexDes.attributes[1].format = .float2
        vertexDes.attributes[1].offset = MemoryLayout<float2>.size
        
        vertexDes.layouts[0].stride = MemoryLayout<ImageVertex>.stride
        return vertexDes
    }
    
    // Image source protocol
    var consumers: [ImageConsumer]
    
    init(vertext: String = "basic_image_vertex", fragment: String = "basic_image_fragment") {
        
        /*----------------------------
         |-1,1                    1,1 |
         |    0.0              1.0    |
         |                            |
         |    0.1              1.1    |
         |-1,-1                  1,-1 |
         -----------------------------
         */
        
        verties = [
            ImageVertex(position: float2(-1,  1), textCoords: float2(0, 0)),
            ImageVertex(position: float2( 1,  1), textCoords: float2(1, 0)),
            ImageVertex(position: float2(-1, -1), textCoords: float2(0, 1)),
            ImageVertex(position: float2( 1, -1), textCoords: float2(1, 1)),
        ]
        
        vertexBuffer = Renderer.device.makeBuffer(bytes: verties,
                                         length: verties.count * MemoryLayout.stride(ofValue: verties[0]),
                                         options: [])
        
        vertexName = vertext
        fragmentName = fragment
        consumers = []
        renderPipelineState = buildPipelineState(device: Renderer.device)
    }
    
    func updateParameters(for encoder: MTLRenderCommandEncoder) {
        /// This function should be overided by subclass
    }
}

extension ZAOperaion: ImageSource, ImageConsumer {

    // MARK: consumer
    func add(source: ImageSource) { }
    
    func remove(source: ImageSource) {  }
    
    func newTextureAvailable(_ texture: ZATexture, from source: ImageSource) {
        self.texture = texture
        
        for consumer in consumers {
            consumer.newTextureAvailable(texture, from: self)
        }
    }
}

extension ZAOperaion: Renderable {
    
    func draw(commandEncoder: MTLRenderCommandEncoder) {
        if let texture = self.texture {
            
            commandEncoder.setRenderPipelineState(renderPipelineState)
            commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder.setFragmentTexture(texture.texture, index: 0)
            
            updateParameters(for: commandEncoder)
            
            commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: verties.count, instanceCount: 1)
        }
    }
    
}
