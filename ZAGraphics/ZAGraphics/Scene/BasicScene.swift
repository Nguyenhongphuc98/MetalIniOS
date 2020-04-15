//
//  BasicScene.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class BasicScene: Scene {
    
    override init(device: MTLDevice) {
        super.init(device: device)
        
        let triangle1 = Triangle(device: device, color: SIMD4<Float>(1, 0, 0, 1))
        triangle1.scale(axist: SIMD3<Float>.init(repeating: 0.7))
        
        let triangle2 = Triangle(device: device, color: SIMD4<Float>(0, 1, 0, 1))
        triangle2.scale(axist: SIMD3<Float>.init(repeating: 0.5))
        
        add(child: triangle1)
        add(child: triangle2)
    }
}
