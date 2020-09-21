//
//  UIImageView+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 12/24/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UIImageView {

    /**
     Applies `alpha` to `UIImageView.image`
     
     - Parameters:
        - alpha: the alpha component to apply.
     */
    func apply(alpha: CGFloat) {
        image = image?.applying(alpha: alpha)
    }

}
