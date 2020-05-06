//
//  ZAColorSketch.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/27/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

let sharedSketch = ZAColorSketch()

class ZAColorSketch: ZAOperaion {
    
    init() {
        super.init(vertext: "basic_image_vertex", fragment: "sketch_fragment")
    }
}

