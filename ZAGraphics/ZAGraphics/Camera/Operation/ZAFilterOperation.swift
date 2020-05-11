//
//  ZAFilterOperation.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/11/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

public class ZAFilterOperation: ZAOperation {

    var verties: [BasicVertex]! {
        didSet {
            vertexCount = verties.count
        }
    }
    
    init(fragment: String = "basic_image_fragment") {
        super.init(fragment: fragment)
        self.verties = defaulfBasicVerties()
        self.vertexCount = verties.count
        self.vertexBuffer = sharedRenderer.device.makeBuffer(bytes: verties,
                                                        length: verties.count * MemoryLayout.stride(ofValue: verties[0]),
                                                        options: [])
    }
}
