//
//  ZAColorLookupTable.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/19/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZAColorLookupTable: ZABlendOperation {
    
    public var intensity: Float
    
    init(intensity: Float = 1) {
        self.intensity = intensity
        super.init(fragment: "lookup_table_fragment", image: "lookup.png")
    }
    
    override func updateParameters(for encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(&intensity, length: MemoryLayout<Float>.size, index: 2)
        super.updateParameters(for: encoder)
    }
}
