//
//  UIImage+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 12/24/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UIImage {

    /**
     Returns an `UIImage` with the given `alpha`.
     
     - Parameters:
        - alpha: the alpha to apply to the copy of
                 the current `UIImage`.
     */
    func applying(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
