//
//  StringExtension.swift
//  ZAGraphics
//
//  Created by phucnh7 on 5/21/20.
//  Copyright © 2020 phucnh7. All rights reserved.
//

import Foundation

extension String {
    
    subscript (r: Range<Int>) -> String {
      let start = index(startIndex, offsetBy: r.lowerBound)
      let end = index(startIndex, offsetBy: r.upperBound)
      return String(self[start ..< end])
    }
}
