//
//  NSAttributedString+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    
    convenience init(string: String, font: UIFont?, color: UIColor? = nil) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let font = font {
            attributes[.font] = font
        }
        if let color = color {
            attributes[.foregroundColor] = color
        }
        self.init(string: string, attributes: attributes)
    }
    
}

public extension NSMutableAttributedString {
    
    func append(string: String, font: UIFont?, color: UIColor? = nil) {
        append(NSAttributedString(string: string, font: font, color: color))
    }
    
}
