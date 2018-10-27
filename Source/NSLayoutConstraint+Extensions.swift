//
//  NSLayoutConstraint+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    public var priorityRaw: Float {
        get { return priority.rawValue }
        set { priority = UILayoutPriority(newValue) }
    }
    
}
