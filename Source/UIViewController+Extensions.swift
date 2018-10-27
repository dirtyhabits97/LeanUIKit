//
//  UIViewController+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public var isFirstInNavController: Bool {
        return navigationController?.viewControllers.count == 1
    }
    
    public func embedInNavController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
        navController.tabBarItem.title = self.tabBarItem.title ?? self.title
        navController.tabBarItem.image = self.tabBarItem.image
        return navController
    }
    
}
