//
//  Node.swift
//  ZAGraphics
//
//  Created by phucnh7 on 4/15/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import MetalKit

class Node {
    
    var device: MTLDevice!
    
    var children: [Node] = []
    
    func add(child: Node) {
        children.append(child)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder) {
        for child in children {
            child.render(commandEncoder: commandEncoder)
        }
    }
}
