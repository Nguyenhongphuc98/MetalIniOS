//
//  FloatExtension.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

extension Float {
    
    func radians() -> Float {
        return Float(Double.pi) * self / 180
    }
}
