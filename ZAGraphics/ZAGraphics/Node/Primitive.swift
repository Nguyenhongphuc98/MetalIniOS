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
    
    var renderPipelineState: MTLRenderPipelineState!
    
    var modelConstants = ModelConstants()
    
    init(device: MTLDevice) {
        super.init()
        self.device = device
        buildModel()
        buildBuffer()
        buildPipeline()
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
    
    func buildPipeline() {
        let lib = device.makeDefaultLibrary()
        let vertexFunction = lib?.makeFunction(name: "main_vertex")
        let fragmentFunction = lib?.makeFunction(name: "main_fragment")
        let renderPipelineDes = MTLRenderPipelineDescriptor()
        
        renderPipelineDes.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDes.vertexFunction = vertexFunction
        renderPipelineDes.fragmentFunction = fragmentFunction
        
        let vertexDes = MTLVertexDescriptor()
        vertexDes.attributes[0].bufferIndex = 0
        vertexDes.attributes[0].format = .float3
        vertexDes.attributes[0].offset = 0
        
        vertexDes.attributes[1].bufferIndex = 0
        vertexDes.attributes[1].format = .float4
        vertexDes.attributes[1].offset = MemoryLayout<SIMD3<Float>>.size
        
        vertexDes.layouts[0].stride = MemoryLayout<Vertex>.stride
        renderPipelineDes.vertexDescriptor = vertexDes
        
        do {
            try renderPipelineState = device.makeRenderPipelineState(descriptor: renderPipelineDes)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
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
    
    override func render(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setRenderPipelineState(renderPipelineState)
        super.render(commandEncoder: commandEncoder)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16,
                                             indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}
