//
//  BasicScene.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class BasicScene: Scene {
    
    var c: Cube!
    
    override init(device: MTLDevice) {
        super.init(device: device)
        
        c = Cube(device: device)
        c.position.z = -7
        
        //c.scale(axist: SIMD3<Float>.init(repeating: 0.7))
        
        add(child: c)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, angle: Float) {
        c.rotation.x += angle
        render(commandEncoder: commandEncoder)
    }
}
