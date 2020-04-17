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
    
    var vertexDes: MTLVertexDescriptor { get }
    
    func draw(commandEncoder: MTLRenderCommandEncoder)
}

extension Renderable {
    
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
}
