//
//  ZAEffectVideoMask.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/29/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

class ZAEffectVideoMask: ZABlendOperation {

    init() {
        super.init(fragment: "videomask_fragment")
    }
}
