//
//  UIButton+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UIButton {
    
    /// Proxy property for the button's title.
    var title: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
    /// Proxy property for the button's attributed title.
    var attributedTitle: NSAttributedString? {
        get { return attributedTitle(for: .normal) }
        set { setAttributedTitle(newValue, for: .normal) }
    }
    /// Proxy property for the button's title color.
    var titleColor: UIColor? {
        get { return titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }
    
}

public extension UIButton {
    
    /**
     Creates a `UIButton` with rounded corners.
     
     - Parameters:
        - cornerRadius: the corner radius to use for the rounded corners.
     */
    static func roundedButton(cornerRadius: CGFloat) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        return button
    }
    
}
