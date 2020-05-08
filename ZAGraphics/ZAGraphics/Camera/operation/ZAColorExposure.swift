//
//  ZAColorExposure.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/8/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

public class ZAColorExposure: ZAOperation {

    /// The range of value  is -10.0 to 10.0
    public var exposure: Float
    
    init(exposure: Float = 0.5) {
        self.exposure = exposure
        super.init(fragment: "exposure_fragment")
    }
    
    override func updateParameters(for encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(&exposure, length: MemoryLayout<Float>.size, index: 1)
    }
}
