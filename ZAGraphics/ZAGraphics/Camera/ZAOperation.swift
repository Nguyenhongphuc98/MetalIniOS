//
//  ZAOperation.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

protocol ImageConsumer {
    func newTextureAvailable(_ texture: ZATexture)
}

class ZAOperaion {
    
    var verties: [ImageVertex]!
    
    var vertexBuffer: MTLBuffer!
    
    //renderable protocol
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
    
    init(vertext: String, fragment: String) {
        
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
        renderPipelineState = buildPipelineState(device: Renderer.device)
    }
}

extension ZAOperaion: ImageConsumer {
    
    func newTextureAvailable(_ texture: ZATexture) {
        self.texture = texture
    }
}

extension ZAOperaion: Renderable {
    
    func draw(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        if texture != nil {
            commandEncoder.setRenderPipelineState(renderPipelineState)
            commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            
            commandEncoder.setFragmentTexture(texture.texture, index: 0)
            commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: verties.count, instanceCount: 1)
        }
    }
    
}
