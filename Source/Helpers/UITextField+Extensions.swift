//
//  UITextField+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

public extension UITextField {
    
    /// A Boolean value indicating whether `UITextField.text` has no characters.
    var isEmpty: Bool { return text?.isEmpty ?? true }
    /// A Boolean value indicating whether `UITextField.cleanText` has content.
    var isClean: Bool { return cleanText != nil }
    /// The trimmed `UITextField.text`.
    var cleanText: String? {
        guard let trimmed = text?.trimmingCharacters(in: .whitespaces) else { return nil }
        return trimmed.isEmpty ? nil : trimmed
    }
    /// The left side padding of the textfield.
    var paddingLeft: CGFloat {
        get { return leftView?.frame.width ?? 0 }
        set {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 0))
            leftViewMode = .always
        }
    }
    /// The right side padding of the textfield.
    var paddingRight: CGFloat {
        get { return rightView?.frame.width ?? 0 }
        set {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 0))
            rightViewMode = .always
        }
    }
    
}

public extension UITextField {
    
    /// The strongly typed keyboard style
    enum KeyboardStyle {
        
        case email
        case password
        case numbers
        case phonenumber
        case normal
        
    }
    
    /// The style of the keyboard for this `UITextField`.
    var keyboardStyle: KeyboardStyle {
        get { return keyboardType.toKeyboardStyle(secureText: isSecureTextEntry) }
        set { setStyle(newValue) }
    }
    
    /**
     - Parameters:
        - keyboardStyle: the keyboard style to use for this `UITextField`.
     */
    convenience init(keyboardStyle: KeyboardStyle) {
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

private extension UITextField {
    
    /**
     Configures the `UITextField` by the given `KeyboardStyle`.
     
     - Parameters:
        - keyboardStyle: the keyboard style to use to configure the `UITextField.keyboardType`
     */
    func setStyle(_ keyboardStyle: KeyboardStyle) {
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

private extension UIKeyboardType {
    
    /**
     Maps `UIKeyboardType` to `UITextField.KeyboardStyle`
     
     - Parameters:
        - secureText: flag indicating wheter the text needs to be hidden.
     */
    func toKeyboardStyle(secureText: Bool = false) -> UITextField.KeyboardStyle {
        switch self {
        case .emailAddress: return .email
        case .numbersAndPunctuation: return .numbers
        case .phonePad: return .phonenumber
        default: return secureText ? .password : .normal
        }
    }
    
}
