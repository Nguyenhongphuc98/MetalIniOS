//
//  ViewController.swift
//  CollectionNode
//
//  Created by phucnh7 on 5/4/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AsyncDisplayKit

class ViewController: UIViewController {
    
    var colectionNode: ZACollectionNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
//        let vc = DemoViewController()
//        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: ZACollectionDelegate {
    func collectionNode(_ collectionNode: ZACollectionNode, didSelectItemAt indexPath: IndexPath, with model: PhotoModel) {
        print("did click: \(indexPath.row)")
    }
}
