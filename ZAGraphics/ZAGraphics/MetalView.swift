//
//  MetalView.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    
    var renderer: Renderer!
    

    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        device = MTLCreateSystemDefaultDevice()
        colorPixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(red: 0.5, green:0.3, blue: 0.9, alpha: 1)
        
        renderer = Renderer(device: device!)
        delegate = renderer
    }
}
