//
//  ZAColorSketch.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/27/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

let sharedSketch = ZAColorSketch()

class ZAColorSketch: ZAFilterOperation {
    
    public var strokeWidth: Float
    
    init(strokeWidth: Float = 1) {
        self.strokeWidth = strokeWidth
        super.init(fragment: "sketch_fragment")
    }
    
    override func updateParameters(for encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(&strokeWidth, length: MemoryLayout<Float>.size, index: 1)
    }
}

