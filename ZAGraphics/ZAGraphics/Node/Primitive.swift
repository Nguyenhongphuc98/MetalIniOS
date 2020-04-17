//
//  Primitive.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Primitive: Node {
    
    var verties: [Vertex]!
    
    var indices: [UInt16]!
    
    var vertexBuffer: MTLBuffer!
    
    var indexBuffer: MTLBuffer!
    
    //renderable protocol
    var vertexName: String
    
    var fragmentName: String
    
    var renderPipelineState: MTLRenderPipelineState!
    
    //textureable protocol
    var texture: MTLTexture?
    
    var vertexDes: MTLVertexDescriptor {
        let vertexDes = MTLVertexDescriptor()
        vertexDes.attributes[0].bufferIndex = 0
        vertexDes.attributes[0].format = .float3
        vertexDes.attributes[0].offset = 0
        
        vertexDes.attributes[1].bufferIndex = 0
        vertexDes.attributes[1].format = .float4
        vertexDes.attributes[1].offset = MemoryLayout<SIMD3<Float>>.size
        
        vertexDes.attributes[2].bufferIndex = 0
        vertexDes.attributes[2].format = .float2
        vertexDes.attributes[2].offset = MemoryLayout<SIMD3<Float>>.size + MemoryLayout<SIMD4<Float>>.size
        
        vertexDes.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDes
    }
    
    var modelConstants = ModelConstants()
    
    init(device: MTLDevice, image: String) {
        
        vertexName = "main_vertex"
        fragmentName = "main_fragment"
        
        super.init()
        
        if let texture = setTexture(device: device, image: image) {
            self.texture = texture
            fragmentName = "texture_fragment"
        }

        self.device = device
        buildModel()
        buildBuffer()
        renderPipelineState = buildPipelineState(device: device)
    }
    
    func buildModel() {
        
    }
    
    func buildBuffer() {
        vertexBuffer = device.makeBuffer(bytes: verties,
                                         length: verties.count * MemoryLayout.stride(ofValue: verties[0]),
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
    }
    
    func scale(axist: SIMD3<Float>) {
        modelConstants.modelMatrix.scale(axist: axist)
    }
    
    func translate(axist: SIMD3<Float>) {
        modelConstants.modelMatrix.translate(direction: axist)
    }
    
    func rotate(angle: Float, axist: SIMD3<Float>) {
        modelConstants.modelMatrix.rotate(angle: angle, axist: axist)
    }
}

extension Primitive: Renderable {

    func draw(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        commandEncoder.setRenderPipelineState(renderPipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        modelConstants.modelMatrix = modelViewMatrix
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}

extension Primitive: Textureable {
    
}
