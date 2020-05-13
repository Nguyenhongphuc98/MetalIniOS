//
//  ZAStickControl.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/11/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZAStickerControl: UIControl {

    public var didMove: ((_ sender: ZAStickerControl, _ translation: CGPoint) -> ())?
    
    public var didScale: ((_ sender: ZAStickerControl, _ scale: CGFloat) -> ())?
    
    public var didRotate: ((_ sender: ZAStickerControl, _ rotation: CGFloat) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        isExclusiveTouch = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPan(gesture:)))
        addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(userDidPinch(gesture:)))
        addGestureRecognizer(pinchGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(userDidRotate(gesture:)))
        addGestureRecognizer(rotateGesture)
    }
    
    @objc func userDidPan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            print("begin pan")
            
        case .changed:
            let translation = gesture.translation(in: superview)
            
            if let didMove = self.didMove {
                didMove(self, translation)
            }
            
            gesture.setTranslation(CGPoint.zero, in: superview)
            print("moving: \(translation)")
            
        case .ended, .cancelled:
            print("end pan")
            
        default:
            break;
        }
    }
    
    @objc func userDidPinch(gesture: UIPinchGestureRecognizer) {
           
           switch gesture.state {
           case .began:
               print("begin pinch")
               
           case .changed:
               let scale = gesture.scale
               
               if let didScale = self.didScale {
                   didScale(self, scale)
               }
               
               gesture.scale = 1.0
               print("scale: \(scale)")
               
           case .ended, .cancelled:
               print("end pinch")
               
           default:
               break;
           }
       }
    
    @objc func userDidRotate(gesture: UIRotationGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            print("begin rotate")
            
        case .changed:
            let rotation = gesture.rotation
            
            if let didRotate = self.didRotate {
                didRotate(self, rotation)
            }
            
            gesture.rotation = 0
            print("rotated: \(rotation)")
            
        case .ended, .cancelled:
            print("end rotate")
            
        default:
            break;
        }
    }
}

// MARK: recognize delegate
extension ZAStickerControl: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
