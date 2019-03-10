//
//  UIImageView+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 12/24/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    func apply(alpha: CGFloat) {
        image = image?.applying(alpha: alpha)
    }
    
}
