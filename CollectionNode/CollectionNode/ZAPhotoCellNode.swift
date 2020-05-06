//
//  ZAPhotoCellNode.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/4/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AsyncDisplayKit

class ZAPhotoCellNode: ASCellNode {
    let imageNode = ASImageNode()
    
    init(photo: PhotoModel) {
        super.init()
        imageNode.image = photo.image
        self.addSubnode(imageNode)
        self.cornerRoundingType = .defaultSlowCALayer;
        self.cornerRadius = 10
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetlayout = ASInsetLayoutSpec(insets: .zero, child: imageNode)
        return insetlayout
    }
}
