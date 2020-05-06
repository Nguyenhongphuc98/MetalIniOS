//
//  ZAColorInversion.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/22/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

let sharedInversion = ZAColorInversion()

class ZAColorInversion: ZAOperaion {
    
    init() {
        super.init(vertext: "basic_image_vertex", fragment: "inversion_fragment")
    }
}
