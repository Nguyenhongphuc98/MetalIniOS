//
//  Plane.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Plane: Primitive {
    
    override func buildModel() {
        let size: Float = 1
        verties = [
            Vertex(position: SIMD3<Float>(-size, size, 0), color: SIMD4<Float>(1, 0, 0, 1), textCoords: SIMD2<Float>(0, 1)),
            Vertex(position: SIMD3<Float>(-size, -size, 0), color: SIMD4<Float>(0.5, 0.2, 1, 1), textCoords: SIMD2<Float>(0, 0)),
            Vertex(position: SIMD3<Float>(size, -size, 0), color: SIMD4<Float>(0.9, 0.3, 1, 0), textCoords: SIMD2<Float>(1, 0)),
            Vertex(position: SIMD3<Float>(size, size, 0), color: SIMD4<Float>(0.1, 0, 0.7, 0), textCoords: SIMD2<Float>(1, 1))
        ]
        
        indices = [0, 1, 3,
                   1, 2, 3]
    }
}
