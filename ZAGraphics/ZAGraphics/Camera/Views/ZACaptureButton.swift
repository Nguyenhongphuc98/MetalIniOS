//
//  ZACaptureButton.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/20/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZACaptureButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        layer.borderColor = UIColor.brown.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = frame.width / 2
    }
}
