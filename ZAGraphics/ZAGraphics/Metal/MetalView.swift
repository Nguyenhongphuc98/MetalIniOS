//
//  MetalView.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/13/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    
    //var renderer: Renderer!

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, device: sharedRenderer.device)
        setup()
    }
    
    func setup() {
        colorPixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(red: 0, green:0, blue: 0, alpha: 1)
        
        delegate = sharedRenderer
        
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didPpan(sender:)))
//        self.addGestureRecognizer(gesture)
    }
    
//    func toggleWireFrame(isOn: Bool) {
//        renderer.toggleWireFrame(isOn: isOn)
//    }
//
//    @objc func didPpan(sender: UIPanGestureRecognizer) {
//        let x: Float = Float(sender.location(in: self).x)
//        let y: Float = Float(sender.location(in: self).y)
//        renderer.mousePosition = float2(x, Float(bounds.height) - y)
//        InputHandler.setMousePosition(position: float2(x, Float(bounds.height) - y))
//    }
}

extension MetalView: ImageConsumer {
    func add(source: ImageSource) { }
    
    func remove(source: ImageSource) { }
    
    func newTextureAvailable(_ texture: ZATexture, from source: ImageSource) {
        
    }
}
