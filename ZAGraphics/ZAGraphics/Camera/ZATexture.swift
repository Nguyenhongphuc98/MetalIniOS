//
//  ZATexture.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

public class ZATexture: Textureable {
    
    /**
         Texture using for process video output
    */
    
    var texture: MTLTexture!
    
    /// Should use when have a available MTLTexture, ex: from camera source
    init(texture: MTLTexture) {
        self.texture = texture
    }
    
    /// Should use when need process new texture, ex: filter operation
    init(device: MTLDevice, width: Int, height: Int) {
        let textureDes = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                  width: width,
                                                                  height: height,
                                                                  mipmapped: false)
        textureDes.usage = [.renderTarget, .shaderRead, .shaderWrite]
        guard let texture = sharedRenderer.device.makeTexture(descriptor: textureDes) else {
            fatalError("Could't make new Texture!")
        }
        
        self.texture = texture
    }
}
