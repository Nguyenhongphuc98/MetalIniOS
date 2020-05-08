//
//  ZAEffectCrosshatch.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/8/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

public class ZAEffectCrosshatch: ZAOperation {

    /// Process image to black-white color and have crosshatch (+++)
    
    public var crosshatchSpacing: Float
    
    public var lineWidth: Float
    
    init(crosshatchSpacing: Float = 0.01, lineWidth: Float = 0.003) {
        self.crosshatchSpacing = crosshatchSpacing
        self.lineWidth = lineWidth
        super.init(fragment: "crosshatch_fragment")
    }
    
    override func updateParameters(for encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(&crosshatchSpacing, length: MemoryLayout<Float>.size, index: 1)
        encoder.setFragmentBytes(&lineWidth, length: MemoryLayout<Float>.size, index: 2)
    }
}
