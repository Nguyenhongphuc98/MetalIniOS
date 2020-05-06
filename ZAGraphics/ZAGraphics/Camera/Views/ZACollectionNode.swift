//
//  ZACollectionNode.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/4/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import AsyncDisplayKit

public protocol ZACollectionDelegate {
    func collectionNode(_ collectionNode: ZACollectionNode, didSelectItemAt indexPath: IndexPath, with model: PhotoModel)
}

public protocol ZACollectionDatasource {
    func dataSourceFor(collection: ZACollectionNode) -> [PhotoModel]?
}


open class ZACollectionNode: ASDisplayNode {
    
    public var colectionNode: ASCollectionNode!
    
    public var viewLayout: UICollectionViewFlowLayout!
    
    private var photos:[PhotoModel]?
    
    public var delegate: ZACollectionDelegate?
    
    public var dataSource: ZACollectionDatasource?
    
    public override init() {
        viewLayout = UICollectionViewFlowLayout()
        colectionNode = ASCollectionNode(collectionViewLayout: viewLayout)
        
        super.init()
        
        backgroundColor = UIColor(white: 1, alpha: 0)
        colectionNode.backgroundColor = UIColor(white: 1, alpha: 0)
        colectionNode.showsHorizontalScrollIndicator = false
        
        viewLayout.minimumInteritemSpacing = 1
        viewLayout.minimumLineSpacing = 5
        viewLayout.scrollDirection = .horizontal
        viewLayout.itemSize = CGSize(width: 80, height: 80)
        
        colectionNode.dataSource = self
        colectionNode.delegate = self
        automaticallyManagesSubnodes = true
        
        
    }
    
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let colectionInset = ASInsetLayoutSpec(insets: .zero, child: colectionNode)
        return colectionInset
    }
    
    public func reloadData() {
        guard let models = dataSource?.dataSourceFor(collection: self) else {
            return
        }
        
        photos = models
        colectionNode.reloadData()
    }
}

extension ZACollectionNode: ASCollectionDataSource {
    
    public func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard let photos = self.photos, photos.count > indexPath.row else { return { ASCellNode() } }
          
        let photoModel = photos[indexPath.row]
          
        // this may be executed on a background thread - it is important to make sure it is thread safe
        let cellNodeBlock = { () -> ASCellNode in
          let cellNode = ZAPhotoCellNode(photo: photoModel)
          //cellNode.delegate = self
          return cellNode
        }
          
        return cellNodeBlock
    }
    
    public func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        guard let photos = self.photos else {
            return 0
        }
        return photos.count
    }
}

extension ZACollectionNode: ASCollectionDelegate {
    
    public func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else {
            return
        }
        let model = photos![indexPath.row]
        delegate.collectionNode(self, didSelectItemAt: indexPath, with: model)
    }
}
