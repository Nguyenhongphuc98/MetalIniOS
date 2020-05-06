//
//  DemoViewController.swift
//  CollectionNode
//
//  Created by phucnh7 on 5/4/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AsyncDisplayKit

class DemoViewController: ASViewController<ASDisplayNode> {
    
    var vieww: ASDisplayNode
    var colectionNode: ZACollectionNode
    
    init() {
        vieww = ASDisplayNode()
        colectionNode = ZACollectionNode()
        colectionNode.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        super.init(node: vieww)

        vieww.addSubnode(colectionNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
