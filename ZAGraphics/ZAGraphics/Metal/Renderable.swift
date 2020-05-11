//
//  Renderable.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/17/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

protocol Renderable {
    
    var vertexName: String { get set }
    
    var fragmentName: String { get set }
    
    var renderPipelineState: MTLRenderPipelineState! { get set }
    
    var vertexDes: MTLVertexDescriptor! { get set}
    
    func draw(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4)
    
    func draw()
}

extension Renderable {
    
    func defaulfBasicVerties() -> [BasicVertex] {
        /*----------------------------
         |-1,1                    1,1 |
         |    0.0              1.0    |
         |                            |
         |    0.1              1.1    |
         |-1,-1                  1,-1 |
         -----------------------------
         */
        
        let verties = [
            BasicVertex(position: float2(-1,  1), textCoords: float2(0, 0)),
            BasicVertex(position: float2( 1,  1), textCoords: float2(1, 0)),
            BasicVertex(position: float2(-1, -1), textCoords: float2(0, 1)),
            BasicVertex(position: float2( 1, -1), textCoords: float2(1, 1)),
        ]
        return verties
    }
    
    func defaulfTwoInputVerties() -> [TwoInputVertex] {
        /*----------------------------
         |-1,1                    1,1 |
         |    0.0              1.0    |
         |                            |
         |    0.1              1.1    |
         |-1,-1                  1,-1 |
         -----------------------------
         */
        
        let verties = [
            TwoInputVertex(position: float2(-1,  1), textCoords1: float2(0, 0), textCoords2: float2(0, 0)),
            TwoInputVertex(position: float2( 1,  1), textCoords1: float2(1, 0), textCoords2: float2(1, 0)),
            TwoInputVertex(position: float2(-1, -1), textCoords1: float2(0, 1), textCoords2: float2(0, 1)),
            TwoInputVertex(position: float2( 1, -1), textCoords1: float2(1, 1), textCoords2: float2(1, 1)),
        ]
        return verties
    }
    
    func buildPipelineState(device: MTLDevice) -> MTLRenderPipelineState {
        let lib = device.makeDefaultLibrary()
        let vertexFunction = lib?.makeFunction(name: vertexName)
        let fragmentFunction = lib?.makeFunction(name: fragmentName)
        let renderPipelineDes = MTLRenderPipelineDescriptor()
        
        renderPipelineDes.colorAttachments[0].pixelFormat = .bgra8Unorm
        //renderPipelineDes.depthAttachmentPixelFormat = .depth32Float
        renderPipelineDes.vertexFunction = vertexFunction
        renderPipelineDes.fragmentFunction = fragmentFunction
        
        
        renderPipelineDes.vertexDescriptor = vertexDes
        
        var renderPipelineState: MTLRenderPipelineState! = nil
        do {
            try renderPipelineState = device.makeRenderPipelineState(descriptor: renderPipelineDes)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        return renderPipelineState
    }
    
    func draw(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) { }
    
    func draw() { }
}
