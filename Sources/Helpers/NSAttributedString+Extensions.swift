//
//  NSAttributedString+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension NSAttributedString {

    /**
     - Parameters:
        - string: the string to use.
        - font: the `NSAttributedString.Key.font` to use.
        - color: the `NSAttributedString.Key.foregroundColor` to use.
     */
    convenience init(
        string: String,
        font: UIFont?,
        color: UIColor? = nil
    ) {
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

    /**
     Appends an `NSAttributedString` built from the passed params.
     
     - Parameters:
        - string: the string to use.
        - font: the `NSAttributedString.Key.font` to use.
        - color: the `NSAttributedString.Key.foregroundColor` to use.
     */
    func append(
        string: String,
        font: UIFont?,
        color: UIColor? = nil
    ) {
        append(NSAttributedString(string: string, font: font, color: color))
    }

}
