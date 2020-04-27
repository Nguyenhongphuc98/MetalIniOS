//
//  ZATexture.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class ZATexture: Textureable {
    
    /**
         texture using for preview camera (take photo, video, ...)
         */
    var texture: MTLTexture?
    
    init(texture: MTLTexture) {
        self.texture = texture
    }
}
