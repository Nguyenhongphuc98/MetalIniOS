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
    
    var verties: [Vertex]!
    
    var indices: [UInt16]!
    
    var vertexBuffer: MTLBuffer!
    
    var indexBuffer: MTLBuffer!
    
    var constant = Constants()
    
    var timer: Float = 0.05
    
    init(device: MTLDevice) {
        self.device = device
        super.init()
        
        commandQueue = device.makeCommandQueue()
        buildModel()
        setupPipeline()
    }
    
    func buildModel() {
        let size: Float = 0.5
        verties = [
            Vertex(position: float3(-size, size, 0), color: float4(1, 0, 0, 1)),
            Vertex(position: float3(-size, -size, 0), color: float4(0.5, 0.2, 1, 1)),
            Vertex(position: float3(size, -size, 0), color: float4(0.9, 0.3, 1, 0)),
            Vertex(position: float3(size, size, 0), color: float4(0.1, 0, 0.7, 0))
        ]
        
        indices = [0, 1, 3,
                   1, 2, 3]
        
        vertexBuffer = device.makeBuffer(bytes: verties,
                                         length: verties.count * MemoryLayout.stride(ofValue: verties[0]),
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
    }
    
    func setupPipeline() {
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
        vertexDes.attributes[1].format = .float3
        vertexDes.attributes[1].offset = 0
        
        vertexDes.layouts[0].stride = MemoryLayout<Vertex>.stride
        renderPipelineDes.vertexDescriptor = vertexDes
        
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
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        timer += 0.05
        constant.anmateBy = sin(timer)
        commandEncoder?.setVertexBytes(&constant, length: MemoryLayout<Constants>.stride, index: 1)
        
        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
