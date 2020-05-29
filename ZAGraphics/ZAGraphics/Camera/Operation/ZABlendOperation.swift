//
//  BlendOperation.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/11/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class ZABlendOperation: ZAOperation {
    
    var verties: [TwoInputVertex]! {
        didSet {
            vertexCount = verties.count
        }
    }
    
    init(fragment: String = "two_image_fragment") {
        super.init(vertext: "two_image_vertex", fragment: fragment)
        
        verties = defaulfTwoInputVerties()
        setupVerties()
        designateVerTexDes()
        setup()
    }
    
    public func designateVerTexDes() {
        vertexDes = MTLVertexDescriptor()
        vertexDes.attributes[0].bufferIndex = 0
        vertexDes.attributes[0].format = .float2
        vertexDes.attributes[0].offset = 0
        
        vertexDes.attributes[1].bufferIndex = 0
        vertexDes.attributes[1].format = .float2
        vertexDes.attributes[1].offset = MemoryLayout<float2>.size
        
        vertexDes.attributes[2].bufferIndex = 0
        vertexDes.attributes[2].format = .float2
        vertexDes.attributes[2].offset = MemoryLayout<float2>.size * 2
        
        vertexDes.layouts[0].stride = MemoryLayout<TwoInputVertex>.stride
    }
    
    public func updateVerties(topleft: CGPoint, bottomleft: CGPoint, bottomright: CGPoint, topright: CGPoint) {
        verties = [
            TwoInputVertex(position: float2(-1,  1), textCoords1: float2(0, 0), textCoords2: float2(Float(topleft.x), Float(topleft.y))),
            TwoInputVertex(position: float2( 1,  1), textCoords1: float2(1, 0), textCoords2: float2(Float(topright.x), Float(topright.y))),
            TwoInputVertex(position: float2(-1, -1), textCoords1: float2(0, 1), textCoords2: float2(Float(bottomleft.x), Float(bottomleft.y))),
            TwoInputVertex(position: float2( 1, -1), textCoords1: float2(1, 1), textCoords2: float2(Float(bottomright.x), Float(bottomright.y))),
        ]
        
        setupVerties()
    }
    
    func setupVerties() {
        self.vertexCount = verties.count
        self.vertexBuffer = sharedRenderer.device.makeBuffer(bytes: verties,
                                                        length: verties.count * MemoryLayout.stride(ofValue: verties[0]),
                                                        options: [])
    }
}
