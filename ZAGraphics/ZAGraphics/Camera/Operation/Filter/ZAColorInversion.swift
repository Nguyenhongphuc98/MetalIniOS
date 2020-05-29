//
//  ZAColorInversion.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

let sharedInversion = ZAColorInversion()

class ZAColorInversion: ZAFilterOperation {
    
    init() {
        super.init(fragment: "inversion_fragment")
    }
}
