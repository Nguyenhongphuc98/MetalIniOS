//
//  ZABlendSticker.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/12/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZABlendSticker: ZAStaticBlend {

    /// Frame of sticker
    var frame: CGRect!
    
    /// Size of space where sticker placed
    let spaceWidth: CGFloat!
    
    let spaceHeight: CGFloat!
    
    // Rotation of sticker (not include frame)
    var rotation: CGFloat = 0
    
    public let control: ZAStickerControl!
    
    init(frame: CGRect, spaceWidth: CGFloat, spaceHeight: CGFloat, image: String) {
        self.frame = frame
        self.spaceWidth = spaceWidth
        self.spaceHeight = spaceHeight
        
        control = ZAStickerControl(frame: frame)
        
        super.init(fragment: "two_image_fragment", image: image)
        
        updateAppearance(frame: frame)
        
        control.didMove = { [unowned self ] sender, translation in
            self.control.frame.translate(x: translation.x, y: translation.y)
            self.updateAppearance(frame: self.control.frame)
        }
        
        control.didScale = { [unowned self ] sender, scale in
            self.control.frame.scale(sx: scale, sy: scale)
            self.updateAppearance(frame: self.control.frame)
        }
        
        control.didRotate = { [unowned self ] sender, rotation in
            self.rotation += rotation
            self.updateAppearance(frame: self.frame)
        }
    }
    
    func updateAppearance(frame: CGRect) {
        self.frame = frame
        
        /// Convert worldspace to texture space
        let paddingTop = frame.origin.y / frame.height
        let paddingLeft = frame.origin.x / frame.width
        let paddingBottom = (spaceHeight - frame.origin.y - frame.height) / frame.height
        let paddingRight = (spaceWidth - frame.origin.x - frame.width) / frame.width
        
//        let tl = CGPoint(x: -paddingLeft, y: -paddingTop)
//        let bl = CGPoint(x: -paddingLeft, y: 1 + paddingBottom)
//        let br = CGPoint(x: 1 + paddingRight, y: 1 + paddingBottom)
//        let tr = CGPoint(x: 1 + paddingRight, y: -paddingTop)
//
//        super.updateVerties(topleft: tl,
//                                 bottomleft: bl,
//                                 bottomright: br,
//                                 topright: tr)
        
        let tl = CGPoint(x: -paddingLeft, y: -paddingTop)
        let br = CGPoint(x: 1 + paddingRight, y: 1 + paddingBottom)
        
        /// Auto re rotation for sticker in its coordinates space
        var newFrame = CGRect(origin: tl, size: CGSize(width: br.x - tl.x, height: br.y - tl.y))
        let (rotatedTopLeft, rotatedBottomLeft, rotatedBottomRight, rotatedTopRight) = newFrame.rotate(angle: -rotation)
        
        super.updateVerties(topleft: rotatedTopLeft,
                            bottomleft: rotatedBottomLeft,
                            bottomright: rotatedBottomRight,
                            topright: rotatedTopRight)
    }
}
