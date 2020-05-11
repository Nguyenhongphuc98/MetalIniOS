//
//  ZAFilterOperation.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/11/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

public class ZAFilterOperation: ZAOperation {

    var verties: [BasicVertex]! {
        didSet {
            vertexCount = verties.count
        }
    }
    
    init(fragment: String = "basic_image_fragment") {
        super.init(fragment: fragment)
        self.verties = defaulfBasicVerties()
        self.vertexCount = verties.count
        self.vertexBuffer = sharedRenderer.device.makeBuffer(bytes: verties,
                                                        length: verties.count * MemoryLayout.stride(ofValue: verties[0]),
                                                        options: [])
        vertexDes = MTLVertexDescriptor()
        vertexDes.attributes[0].bufferIndex = 0
        vertexDes.attributes[0].format = .float2
        vertexDes.attributes[0].offset = 0
        
        vertexDes.attributes[1].bufferIndex = 0
        vertexDes.attributes[1].format = .float2
        vertexDes.attributes[1].offset = MemoryLayout<float2>.size
        
        vertexDes.layouts[0].stride = MemoryLayout<BasicVertex>.stride
        
        self.setup()
    }
}
