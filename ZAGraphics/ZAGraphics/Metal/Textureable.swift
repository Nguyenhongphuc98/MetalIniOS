//
//  Textureable.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/17/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

protocol Textureable {
    
    var texture: MTLTexture! { get set }
    
}

extension Textureable {
    
    func setTexture(device: MTLDevice, image: String) -> MTLTexture? {
        var texture: MTLTexture? = nil
        
        if image != "" {
            let textureLoader = MTKTextureLoader(device: device)
            let url = Bundle.main.url(forResource: image, withExtension: nil)
            
           // let origin = String(MTKTextureLoaderOriginBottomLeft)
            let options = [MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.bottomLeft]
            do {
                texture = try textureLoader.newTexture(URL: url!, options: options)
            } catch let e {
                print("err \(e)")
            }
        }
        
        return texture
    }
    
    func width() -> Int {
        return texture.width
    }
    
    func height() -> Int {
        return texture.height
    }
}
