//
//  ZACameraView.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/18/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZACameraView: PreviewMetalView {

    // Focus view is view apear when tap to screen
    // Visualize focus center
    var focusView: FocusCameraView!
    
    var didFocus: ((_ position: CGPoint)->())?
    
    var didZoom: ((_ scale: CGFloat)->())?
    
    var didEndZoom: ((_ scale: CGFloat)->())?

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userDidTap(sender:)))
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(userDidPinch(sender:)))
        addGestureRecognizer(pinchGesture)
        
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
        }
    }
    
    @objc func userDidPinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .changed, let didZoom = self.didZoom {
            didZoom(sender.scale)
        }
        
        if sender.state == .ended, let didEnd = self.didEndZoom {
            didEnd(sender.scale)
        }
    }
}
