//
//  NSLayoutAnchor+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension NSLayoutAnchor {
    
    @objc @discardableResult
    public func equals(anchor: NSLayoutAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @objc @discardableResult
    public func greaterOrEquals(anchor: NSLayoutAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @objc @discardableResult
    public func lessOrEquals(anchor: NSLayoutAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
}
