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
            Vertex(position: float3(-size, size, 0), color: float4(1, 0, 0, 1), textCoords: float2(0, 1)),
            Vertex(position: float3(-size, -size, 0), color: float4(0.5, 0.2, 1, 1), textCoords: float2(0, 0)),
            Vertex(position: float3(size, -size, 0), color: float4(0.9, 0.3, 1, 0), textCoords: float2(1, 0)),
            Vertex(position: float3(size, size, 0), color: float4(0.1, 0, 0.7, 0), textCoords: float2(1, 1))
        ]
        
        indices = [0, 1, 3,
                   1, 2, 3]
    }
}
