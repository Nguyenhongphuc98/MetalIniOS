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
        clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        renderer = Renderer(device: device!)
        delegate = renderer
    }
}
