//
//  StickControl.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/11/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZAStickControl: UIControl {

    public var didMove: ((_ sender: ZAStickControl, _ translation: CGPoint) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = .white
        isExclusiveTouch = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPan(gesture:)))
        addGestureRecognizer(panGesture)
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
}
