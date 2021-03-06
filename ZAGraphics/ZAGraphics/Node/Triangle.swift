//
//  Triangle.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Triangle: Primitive {
    
    var color: float4!
    
    init(device: MTLDevice, color: float4) {
        self.color = color
        super.init(device: device, image: "")
    }
    
    override func buildModel() {
//        let size: Float = 1
//        verties = [
//            Vertex(position: SIMD3<Float>(0, size, 0), color: color),
//            Vertex(position: SIMD3<Float>(-size, -size, 0), color: color),
//            Vertex(position: SIMD3<Float>(size, -size, 0), color: color),
//        ]
        
        indices = [0, 1, 2]
    }
}
