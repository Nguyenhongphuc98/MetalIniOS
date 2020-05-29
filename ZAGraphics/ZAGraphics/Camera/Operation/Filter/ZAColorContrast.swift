//
//  ZAColorContrast.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/8/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

public class ZAColorContrast: ZAFilterOperation {

    /// The range of value 0.0 to 4.0
    public var contrast: Float
    
    init(contrast: Float = 1.5) {
        self.contrast = contrast
        super.init(fragment: "contrast_fragment")
    }
    
    override func updateParameters(for encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(&contrast, length: MemoryLayout<Float>.size, index: 1)
    }
}
