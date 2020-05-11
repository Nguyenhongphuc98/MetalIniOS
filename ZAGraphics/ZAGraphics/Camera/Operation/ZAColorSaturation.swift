//
//  ZAColorSaturation.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/4/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZAColorSaturation: ZAFilterOperation {

    public var saturation: Float
    
    init(saturation: Float = 2) {
        self.saturation = saturation
        super.init(fragment: "saturation_fragment")
    }
    
    override func updateParameters(for encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(&saturation, length: MemoryLayout<Float>.size, index: 1)
    }
}
