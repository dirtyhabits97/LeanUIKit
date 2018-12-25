//
//  UIView+Extensions.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

extension UIView {
    
    public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    public var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
}

extension UIView {
    
    public func fillSuperView() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.equals(anchor: superview.topAnchor)
        bottomAnchor.equals(anchor: superview.bottomAnchor)
        leadingAnchor.equals(anchor: superview.leadingAnchor)
        trailingAnchor.equals(anchor: superview.trailingAnchor)
    }
    
    public func addAndFill(withSubView view: UIView) {
        addSubview(view)
        view.fillSuperView()
    }
    
    public func embedInVerticalScrollView(relativeTo parentView: UIView) -> UIScrollView {
        let scrollView = embedInScrollView(relativeTo: parentView)
        let heightContraint = heightAnchor.constraint(equalTo: parentView.heightAnchor)
        heightContraint.priorityRaw = 250
        heightContraint.isActive = true
        widthAnchor.equals(anchor: parentView.widthAnchor)
        return scrollView
    }
    
    public func embedInHorizontalScrollView(relativeTo parentView: UIView) -> UIScrollView {
        let scrollView = embedInScrollView(relativeTo: parentView)
        let widthConstraint = widthAnchor.constraint(equalTo: parentView.widthAnchor)
        widthConstraint.priorityRaw = 250
        widthConstraint.isActive = true
        heightAnchor.equals(anchor: parentView.heightAnchor)
        return scrollView
    }
    
    private func embedInScrollView(relativeTo parentView: UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        scrollView.addAndFill(withSubView: self)
        parentView.addAndFill(withSubView: scrollView)
        return scrollView
    }
    
    public func findMarginConstraint(withView otherView: UIView, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        let filteredConstraints = constraints.filter({ constraint in
            guard constraint.firstAttribute == attribute && constraint.secondAttribute == attribute else {
                return false
            }
            guard constraint.firstItem === otherView && constraint.secondItem === self ||
                constraint.firstItem === self && constraint.secondItem === otherView else {
                    return false
            }
            return true
        })
        guard filteredConstraints.count == 1 else { return nil }
        return filteredConstraints.first
    }
    
}

extension UIView {
    
    public var horizontalHuggingPriority: UILayoutPriority {
        get { return contentHuggingPriority(for: .horizontal) }
        set { setContentHuggingPriority(newValue, for: .horizontal) }
    }
    
    public var verticalHuggingPriority: UILayoutPriority {
        get { return contentHuggingPriority(for: .vertical) }
        set { setContentHuggingPriority(newValue, for: .vertical) }
    }
    
    public var horizontalCompressionPriority: UILayoutPriority {
        get { return contentCompressionResistancePriority(for: .horizontal) }
        set { setContentCompressionResistancePriority(newValue, for: .horizontal) }
    }
    
    public var verticalCompressionPriority: UILayoutPriority {
        get { return contentCompressionResistancePriority(for: .vertical) }
        set { setContentCompressionResistancePriority(newValue, for: .vertical) }
    }
    
}
