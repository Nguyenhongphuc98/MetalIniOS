//
//  InputHandler.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/17/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

enum KEY_CODES: Int {
    case UP = 0
    case DOWN = 1
    case LEFT = 2
    case RIGHT = 3
    case NEAR = 4
    case FAR = 5
}

class InputHandler {
    
    private static var KEY_COUNT = 256

    private static var keyList = [Bool].init(repeating: false, count: KEY_COUNT)
    
    private static var mousePosition = float2(0)
    
    public static var cameraMode: Bool = false //transform mode
    
    public static func setMousePosition(position: float2) {
        mousePosition = position
    }
    
    public static func getMousePosition() -> float2 {
        return mousePosition
    }
    
    public static func setKeyPressed(key: KEY_CODES, isOn: Bool){
        keyList[Int(key.rawValue)] = isOn
    }
    
    public static func isKeyPressed(key: KEY_CODES)->Bool{
        return keyList[Int(key.rawValue)] == true
    }
    
    public static func changeMode() {
        cameraMode = !cameraMode
    }
}
