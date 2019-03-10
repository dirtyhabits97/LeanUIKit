//
//  UITextView+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UITextView {
    
    var isEmpty: Bool { return text?.isEmpty ?? true }
    var isClean: Bool { return cleanText != nil }
    
    var cleanText: String? {
        guard let trimmed = text?.trimmingCharacters(in: .whitespaces) else { return nil }
        return trimmed.isEmpty ? nil : trimmed
    }
    
}
