//
//  BasicScene.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class BasicScene: Scene {
    
    var c2: Cube!
    var c: Cube!
    var speed: Float = 0.3
    
    var plane: Plane!
    
    override init(device: MTLDevice) {
        super.init(device: device)
        
        c2 = Cube(device: device, image: "zalo-icon.png")
        c = Cube(device: device, image: "")
        c2.position.x = -3
        c.position.x = 3

        plane = Plane(device: device, image: "zalo-icon.png")
        camera.position.z = -10
        add(child: plane)
        //c.scale(axist: SIMD3<Float>.init(repeating: 0.7))
        
        add(child: c2)
        add(child: c)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, angle: Float) {
        c2.rotation.x += angle
        c2.rotation.y += angle
        
        let mousePosition = InputHandler.getMousePosition()
        camera.rotation.y = mousePosition.x / 500
        camera.rotation.x = mousePosition.y / 500
        
        if !InputHandler.cameraMode {
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
