//
//  UIColor+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    public func interpolate(with secondColor: UIColor, fraction: CGFloat) -> UIColor? {
        let f = min(max(0, fraction), 1)
        
        guard let c1 = self.cgColor.components, let c2 = secondColor.cgColor.components else {
            return nil
        }
        
        let r = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}
