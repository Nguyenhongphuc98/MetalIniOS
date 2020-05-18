//
//  FocusCameraView.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/18/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class FocusCameraView: UIView {

    var lineColor: UIColor!
    
    let thickness: CGFloat!
    
    var isHiding: Bool = false
    
    let originSize: CGSize!
    
    let deltaScale: CGFloat = 15
    
    let dividerHeight: CGFloat = 5
    
    required init?(coder: NSCoder) {
        self.originSize = CGSize(width: 100, height: 100)
        self.lineColor = .brown
        self.thickness = 1.0
        super.init(coder: coder)
    }
    
    init(line color: UIColor = UIColor(displayP3Red: 1, green: 215 / 255, blue: 56 /  255, alpha: 1), thickness width: CGFloat = 1.0, frame: CGRect) {
        self.originSize = frame.size
        self.lineColor = color
        self.thickness = width
        
        super.init(frame: frame)
        isOpaque = false
        isUserInteractionEnabled = false
    }
    
    public func setFrame(frame: CGRect) {
        super.frame = frame
        
        if !isHidden {
            //notify to system can ve lai content trong drawing cycle tiep theo
            setNeedsDisplay()
        }
    }

    public func setHidden(isHidden: Bool, isAnimate: Bool) {
        //neu dang animate thi thoi
        guard !isHiding else {
            return
        }
        
        if isAnimate {
            isHiding = true
            
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.isHidden = isHidden
            }) { [unowned self] (finished) in
                if finished {
                    self.isHidden = isHidden
                    self.isHiding = false
                }
            }
        } else {
            self.isHidden = isHidden
        }
    }
    
    public func animate(location: CGPoint) {
        
        self.setFrame(frame: CGRect(x: location.x - originSize.width / 2,
                                    y: location.y -  originSize.height / 2,
                                    width: originSize.width,
                                    height: originSize.height))
        
        let newFrame = CGRect(x: self.frame.origin.x + self.deltaScale,
                              y: self.frame.origin.y + self.deltaScale,
                              width: self.originSize.width - self.deltaScale * 2,
                              height: self.originSize.height - self.deltaScale * 2)
        
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.setHidden(isHidden: false, isAnimate: true)
            self.frame = newFrame
        }) { (finished) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.setHidden(isHidden: true, isAnimate: true)
                self.frame = CGRect(origin: self.frame.origin, size: self.originSize)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        lineColor.setFill()
        
        let width = rect.size.width
        let height = rect.size.height
        
        //Top Edge
        UIRectFill(CGRect(x: 0.0, y: 0.0, width: width, height: thickness))
        
        //Left Edge
        UIRectFill(CGRect(x: 0.0, y: 0.0, width: thickness, height: height))
        
        //Bottom Edge
        UIRectFill(CGRect(x: 0.0, y: height - thickness, width: width, height: thickness))
        
        //Right Edge
        UIRectFill(CGRect(x: width - thickness, y: 0.0, width: thickness, height: height))
        
        //Top Center
        UIRectFill(CGRect(x: width / 2, y: 0.0, width: thickness, height: dividerHeight))
        
        //Left Center
        UIRectFill(CGRect(x: 0.0, y: height / 2, width: dividerHeight, height: thickness))
        
        //Bottom Center
        UIRectFill(CGRect(x: width / 2, y: height - dividerHeight, width: thickness, height: dividerHeight))
        
        //Right Center
        UIRectFill(CGRect(x: width - dividerHeight, y: height / 2, width: dividerHeight, height: thickness))
    }

}
