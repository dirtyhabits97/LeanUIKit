//
//  UITabBarController+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 4/27/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UITabBarController {

    /**
     Returns the index of the first `UIViewController` of the given type
     in the `UITabBarController.viewControllers` stack.
     
     - Parameters:
        - viewControllerType: the type of viewcontroller to look up.
     */
    func index<V: UIViewController>(for viewControllerType: V.Type) -> Int? {
        guard let viewControllers = self.viewControllers else { return nil }
        for index in viewControllers.indices where viewControllers[index] is V {
            return index
        }
        return nil
    }

}
