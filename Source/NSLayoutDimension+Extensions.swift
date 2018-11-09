//
//  NSLayoutDimension+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 11/8/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension NSLayoutDimension {
    
    public func equals(constant: CGFloat) {
        constraint(equalToConstant: constant).isActive = true
    }
    
}
