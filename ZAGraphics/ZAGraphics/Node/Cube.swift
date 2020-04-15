//
//  Cube.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Cube: Primitive {
    
    var color: SIMD4<Float>!
    
    override init(device: MTLDevice) {
        super.init(device: device)
    }
    
    override func buildModel() {
    
        verties = [
            Vertex(position: SIMD3<Float>(-1,  1, 1), color: SIMD4<Float>(1, 0, 0, 1)),
            Vertex(position: SIMD3<Float>( 1,  1, 1), color: SIMD4<Float>(0, 1, 0, 1)),
            Vertex(position: SIMD3<Float>( 1, -1, 1), color: SIMD4<Float>(0, 0, 1, 1)),
            Vertex(position: SIMD3<Float>(-1, -1, 1), color: SIMD4<Float>(1, 0, 0.5, 1)),
            
            Vertex(position: SIMD3<Float>(-1,  1, -1), color: SIMD4<Float>(1, 0.7, 0, 1)),
            Vertex(position: SIMD3<Float>( 1,  1, -1), color: SIMD4<Float>(0.6, 0, 0, 1)),
            Vertex(position: SIMD3<Float>( 1, -1, -1), color: SIMD4<Float>(1, 0, 0.8, 1)),
            Vertex(position: SIMD3<Float>(-1, -1, -1), color: SIMD4<Float>(0.2, 0.9, 0.3, 1)),
        ]
        
        indices = [0, 1, 3,
                   3, 1, 2,
                   
                   1, 5, 2,
                   2, 5, 6,
                   
                   3, 2, 6,
                   3, 7, 6,
                   
                   0, 4, 7,
                   0, 3, 7,
                   
                   0, 1, 4,
                   5, 1, 4,
                   
                   4, 5, 7,
                   6, 5, 7]
    }
}
