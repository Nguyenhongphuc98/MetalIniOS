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
    var c2: Cube!
    var speed: Float = 0.3
    
    override init(device: MTLDevice) {
        super.init(device: device)
        
        c = Cube(device: device)
        c2 = Cube(device: device)
        //c.position.z = -7
        c2.position.x = -3

        
        camera.position.z = -15
        //c.scale(axist: SIMD3<Float>.init(repeating: 0.7))
        
        add(child: c)
        add(child: c2)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, angle: Float) {
        c.rotation.x += angle
        c.rotation.y += angle
        
        let mousePosition = InputHandler.getMousePosition()
        camera.rotation.y = mousePosition.x / 500
        camera.rotation.x = mousePosition.y / 500
        
        if InputHandler.cameraMode {
            if InputHandler.isKeyPressed(key: .UP)    { c2.position.y += speed  }
            if InputHandler.isKeyPressed(key: .DOWN)  { c2.position.y -= speed  }
            if InputHandler.isKeyPressed(key: .LEFT)  { c2.position.x -= speed  }
            if InputHandler.isKeyPressed(key: .RIGHT) { c2.position.x += speed  }
            if InputHandler.isKeyPressed(key: .NEAR) { c2.position.z += speed  }
            if InputHandler.isKeyPressed(key: .FAR) { c2.position.z -= speed  }
        } else {
            if InputHandler.isKeyPressed(key: .UP)    { camera.position.y += speed  }
            if InputHandler.isKeyPressed(key: .DOWN)  { camera.position.y -= speed  }
            if InputHandler.isKeyPressed(key: .LEFT)  { camera.position.x -= speed  }
            if InputHandler.isKeyPressed(key: .RIGHT) { camera.position.x += speed  }
            if InputHandler.isKeyPressed(key: .NEAR) { camera.position.z += speed  }
            if InputHandler.isKeyPressed(key: .FAR) { camera.position.z -= speed  }
        }
        
        render(commandEncoder: commandEncoder)
    }
}
