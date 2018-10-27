//
//  NSLayoutAnchor+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension NSLayoutAnchor {
    
    @objc public func equals(anchor: NSLayoutAnchor, constant: CGFloat = 0) {
        constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    @objc public func greaterOrEquals(anchor: NSLayoutAnchor, constant: CGFloat = 0) {
        constraint(greaterThanOrEqualTo: anchor, constant: constant).isActive = true
    }
    
    @objc public func lessOrEquals(anchor: NSLayoutAnchor, constant: CGFloat = 0) {
        constraint(lessThanOrEqualTo: anchor, constant: constant).isActive = true
    }
    
}
