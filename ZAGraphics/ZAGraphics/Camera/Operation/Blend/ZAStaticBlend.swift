//
//  ZAStaticBlend.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/29/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZAStaticBlend: ZABlendOperation {

    /// texture of sticker to apply on other texture
    var texture2: ZATexture!
    
    init(fragment: String, image: String) {
        texture2 = ZATexture(image: image);
        super.init(fragment: fragment)
    }
    
    override func updateParameters(for encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentTexture(texture2.texture, index: 1)
    }
}
