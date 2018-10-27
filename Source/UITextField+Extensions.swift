//
//  UITextField+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension UITextField {
    
    public var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    
    public var isClean: Bool {
        return cleanText != nil
    }
    
    public var cleanText: String? {
        guard let trimmed = text?.trimmingCharacters(in: .whitespaces) else { return nil }
        return trimmed.isEmpty ? nil : trimmed
    }
    
    public var paddingLeft: CGFloat {
        get {
            return leftView?.frame.width ?? 0
        }
        set {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 0))
            leftViewMode = .always
        }
    }
    
    public var paddingRight: CGFloat {
        get {
            return rightView?.frame.width ?? 0
        }
        set {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 0))
            rightViewMode = .always
        }
    }
    
}

extension UITextField {
    
    public enum KeyboardStyle {
        case email, password, numbers, phonenumber, normal
    }
    
    public var keyboardStyle: KeyboardStyle {
        get { return keyboardType.toKeyboardStyle(secureText: isSecureTextEntry) }
        set { setStyle(newValue) }
    }
    
    private func setStyle(_ keyboardStyle: KeyboardStyle) {
        switch keyboardStyle {
        case .email:
            keyboardType = .emailAddress
        case .password:
            keyboardType = .default
            isSecureTextEntry = true
        case .numbers:
            keyboardType = .numbersAndPunctuation
        case .phonenumber:
            keyboardType = .phonePad
        case .normal:
            keyboardType = .default
        }
    }
    
}

extension UITextField {
    
    public convenience init(keyboardStyle: KeyboardStyle) {
        self.init(frame: .zero)
        layer.masksToBounds = true
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        keyboardAppearance = .default
        clearButtonMode = .always
        setStyle(keyboardStyle)
        paddingLeft = 10
    }
    
}

extension UIKeyboardType {
    
    fileprivate func toKeyboardStyle(secureText: Bool = false) -> UITextField.KeyboardStyle {
        switch self {
        case .emailAddress: return .email
        case .numbersAndPunctuation: return .numbers
        case .phonePad: return .phonenumber
        default: return secureText ? .password : .normal
        }
    }
    
}
