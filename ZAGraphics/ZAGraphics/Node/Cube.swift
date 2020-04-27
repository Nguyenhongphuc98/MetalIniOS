//
//  Cube.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Cube: Primitive {
    
    var color:float4!
    
    override init(device: MTLDevice, image: String) {
        super.init(device: device, image: image)
    }
    
    override func buildModel() {
    
        verties = [
             Vertex(position: float3(-0.5, 0.5,-0.5), color: float4(1, 0, 0, 1), textCoords: float2(0,0)),
                       Vertex(position: float3(-0.5,-0.5,-0.5), color:float4(0, 1, 0, 1), textCoords: float2(0,1)),
                       Vertex(position: float3( 0.5,-0.5,-0.5), color:float4(0, 0, 1, 1), textCoords: float2(1,1)),
                       Vertex(position: float3( 0.5, 0.5,-0.5), color:float4(1, 0, 0, 1), textCoords: float2(1,0)),

                       Vertex(position: float3(-0.5, 0.5, 0.5), color:float4(1, 0, 0, 1), textCoords: float2(0,0)),
                       Vertex(position: float3(-0.5,-0.5, 0.5), color:float4(0, 1, 0, 1), textCoords: float2(0,1)),
                       Vertex(position: float3( 0.5,-0.5, 0.5), color:float4(0, 0, 1, 1), textCoords: float2(1,1)),
                       Vertex(position: float3( 0.5, 0.5, 0.5), color:float4(1, 0, 0, 1), textCoords: float2(1,0)),

                       Vertex(position: float3( 0.5, 0.5,-0.5), color:float4(1, 0, 0, 1), textCoords: float2(0,0)),
                       Vertex(position: float3( 0.5,-0.5,-0.5), color:float4(0, 1, 0, 1), textCoords: float2(0,1)),
                       Vertex(position: float3( 0.5,-0.5, 0.5), color:float4(0, 0, 1, 1), textCoords: float2(1,1)),
                       Vertex(position: float3( 0.5, 0.5, 0.5), color:float4(1, 0, 0, 1), textCoords: float2(1,0)),

                       Vertex(position: float3(-0.5, 0.5,-0.5), color:float4(1, 0, 0, 1), textCoords: float2(0,0)),
                       Vertex(position: float3(-0.5,-0.5,-0.5), color:float4(0, 1, 0, 1), textCoords: float2(0,1)),
                       Vertex(position: float3(-0.5,-0.5, 0.5), color:float4(0, 0, 1, 1), textCoords: float2(1,1)),
                       Vertex(position: float3(-0.5, 0.5, 0.5), color:float4(1, 0, 0, 1), textCoords: float2(1,0)),

                       Vertex(position: float3(-0.5, 0.5, 0.5), color:float4(1, 0, 0, 1), textCoords: float2(0,0)),
                       Vertex(position: float3(-0.5, 0.5,-0.5), color:float4(0, 1, 0, 1), textCoords: float2(0,1)),
                       Vertex(position: float3( 0.5, 0.5,-0.5), color:float4(0, 0, 1, 1), textCoords: float2(1,1)),
                       Vertex(position: float3( 0.5, 0.5, 0.5), color:float4(1, 0, 0, 1), textCoords: float2(1,0)),

                       Vertex(position: float3(-0.5,-0.5, 0.5), color:float4(1, 0, 0, 1), textCoords: float2(0,0)),
                       Vertex(position: float3(-0.5,-0.5,-0.5), color:float4(0, 1, 0, 1), textCoords: float2(0,1)),
                       Vertex(position: float3( 0.5,-0.5,-0.5), color:float4(0, 0, 1, 1), textCoords: float2(1,1)),
                       Vertex(position: float3( 0.5,-0.5, 0.5), color:float4(1, 0, 0, 1), textCoords: float2(1,0))
        ]
        
        indices = [0,1,3,              3,1,2,
                    4,5,7,              7,5,6,
                    8,9,11,             11,9,10,
                    12,13,15,           15,13,14,
                    16,17,19,           19,17,18,
                    20,21,23,           23,21,22
            ]
    }
}
