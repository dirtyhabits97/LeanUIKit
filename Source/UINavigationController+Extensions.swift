//
//  UINavigationController+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 4/27/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UINavigationController {
    
    /// Proxy property for the first `UIViewController`
    /// in the `UINavigationController.viewControllers` stack.
    var rootViewController: UIViewController? {
        get { return viewControllers.first }
        set {
            guard let viewController = newValue else { return }
            if viewControllers.count > 0 {
                viewControllers[0] = viewController
            } else {
                viewControllers = [viewController]
            }
        }
    }
    /// Proxy property for the last `UIViewController`
    /// in the `UINavigationController.viewControllers` stack.
    var tailViewController: UIViewController? {
        get { return viewControllers.last }
        set {
            guard let viewController = newValue else { return }
            if viewControllers.count > 0 {
                viewControllers[viewControllers.count - 1] = viewController
            } else {
                viewControllers = [viewController]
            }
        }
    }
    
    /**
     Inserts a new head / root `UIViewController` in the
     `UINavigationController.viewControllers` stack.
     */
    func insert(newRootViewController: UIViewController, animated: Bool = false) {
        setViewControllers(
            [newRootViewController] + viewControllers,
            animated: animated
        )
    }
    
}
