//
//  PreviewMetalView.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/6/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class PreviewMetalView: MTKView {
    
    /// Renderable protocol
    var vertexName: String = "basic_image_vertex"
    
    var fragmentName: String = "basic_image_fragment"
    
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertexDes: MTLVertexDescriptor!
    
    /// properties
    var availableTexture: ZATexture?
    
    var sampleState: MTLSamplerState!
    
    var verties: [BasicVertex]!
    
    var vertexBuffer: MTLBuffer!
    
    var focusView: FocusCameraView!
    
    //Using for take photo
    public var captureTexture: ZATexture!
    
    var didFocus: ((_ position: CGPoint)->())?

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, device: sharedRenderer.device)
        setup()
    }
    
    func setup() {
        
        vertexDes = MTLVertexDescriptor()
        vertexDes.attributes[0].bufferIndex = 0
        vertexDes.attributes[0].format = .float2
        vertexDes.attributes[0].offset = 0
        
        vertexDes.attributes[1].bufferIndex = 0
        vertexDes.attributes[1].format = .float2
        vertexDes.attributes[1].offset = MemoryLayout<float2>.size
        
        vertexDes.layouts[0].stride = MemoryLayout<BasicVertex>.stride
        
        colorPixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(red: 0, green:0, blue: 0, alpha: 1)
        
        verties = defaulfBasicVerties()
        vertexBuffer = sharedRenderer.device.makeBuffer(bytes: verties,
                                                        length: verties.count * MemoryLayout.stride(ofValue: verties[0]),
                                                        options: [])
        renderPipelineState = buildPipelineState(device: sharedRenderer.device)
        buildSampleState()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userDidTap(sender:)))
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
        focusView = FocusCameraView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        focusView.setHidden(isHidden: true, isAnimate: false)
        addSubview(focusView)
    }
    
    @objc func userDidTap(sender: UITapGestureRecognizer) {
       
        if sender.state == .ended, let didTap = self.didFocus {
            // Location using for viusualize on preview camera
            // FocusPoint is real point to map with device
            let location = sender.location(in: superview)
            let focusPoint = CGPoint(x: location.y / self.frame.height, y: 1 - location.x / self.frame.width)
           
            focusView.animate(location: location)
            didTap(focusPoint)
            
            //print("tap at: \(location)")
        }
    }
    
    func buildSampleState() {
        let sampleStateDes = MTLSamplerDescriptor()
        sampleStateDes.minFilter = .linear
        sampleStateDes.magFilter = .linear
        sampleState = sharedRenderer.device.makeSamplerState(descriptor: sampleStateDes)
    }
    
    override func draw(_ rect: CGRect)  {
        
        guard let drawable = currentDrawable,
            let renderPassDes = currentRenderPassDescriptor,
            let newTexture = self.availableTexture else { return }
        
        self.captureTexture = availableTexture
        self.availableTexture = nil
        
        let commandBuffer = sharedRenderer.commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDes)
        commandEncoder?.setFragmentSamplerState(sampleState, index: 0)
        
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.setFragmentTexture(newTexture.texture, index: 0)
        
        commandEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: verties.count, instanceCount: 1)
        commandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

extension PreviewMetalView: ImageConsumer {
    func add(source: ImageSource) { }
    
    func remove(source: ImageSource) { }
    
    func newTextureAvailable(_ texture: ZATexture, from source: ImageSource) {
        availableTexture = texture
        //print("new texture available")
        //self.draw()
    }
}

extension PreviewMetalView: Renderable {
}
