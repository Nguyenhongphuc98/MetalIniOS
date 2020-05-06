//
//  ZAFilterModel.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/4/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import UIKit

public protocol PhotoModel {
    var image: UIImage { get set }
}

class ZAFilterModel: PhotoModel {
    
    var image: UIImage
    
    var filter: ZAOperatorType = .FilterNone
    
    init(image: UIImage, type: ZAOperatorType) {
        self.image = image
        filter = type
    }
}
