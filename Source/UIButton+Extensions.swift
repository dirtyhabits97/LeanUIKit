//
//  UIButton+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension UIButton {
    
    public var title: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
    
    public var attributedTitle: NSAttributedString? {
        get { return attributedTitle(for: .normal) }
        set { setAttributedTitle(newValue, for: .normal) }
    }
    
    public var titleColor: UIColor? {
        get { return titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }
    
}

extension UIButton {
    
    public static func roundedButton(cornerRadius: CGFloat) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        return button
    }
    
}
