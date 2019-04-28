//
//  UIViewController+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    var lastPresentedViewController: UIViewController {
        var current = self
        while current.presentedViewController != nil {
            current = current.presentedViewController!
        }
        return current
    }
    
    var lastVisibleViewController: UIViewController {
        var current: UIViewController = lastPresentedViewController
        var next: UIViewController? = current
        while next != nil {
            current = next!
            if let navigationController = next as? UINavigationController {
                next = navigationController.visibleViewController
            } else if let tabBarController = next as? UITabBarController {
                next = tabBarController.selectedViewController
            } else {
                next = next?.presentedViewController
            }
        }
        return current
    }
    
}

public extension UIViewController {
    
    func embedInNavController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
        navController.tabBarItem.title = tabBarItem.title ?? title
        navController.tabBarItem.image = tabBarItem.image
        return navController
    }
    
}
