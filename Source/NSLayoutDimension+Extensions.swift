//
//  NSLayoutDimension+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 11/8/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension NSLayoutDimension {
    
    @discardableResult
    public func equals(constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func equals(dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: dimension, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func greaterOrEquals(dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualTo: dimension, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func lessOrEquals(dimension: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: dimension, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
}
