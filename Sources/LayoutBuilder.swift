//
//  LayoutBuilder.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 9/21/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit

/**
 Builds the layout for views based on a contraints file.
 */
public final class LayoutBuilder {

    // MARK: - Properties

    /// A flag that indicates if the LayoutBuilder should show the
    /// activated constraints.
    public static var showLogs: Bool = true
    /// The URL where the constraint file is located.
    private let url: URL
    /// The constraint builder.
    private let constraintBuilder: ConstraintBuilder
    /// The constraints that are created from the constraint file.
    private(set) var constraints: [NSLayoutConstraint] = []
    /// Observes changes in the constraint file.
    private var observer: FileObserver?

    // MARK: - Lifecycle

    /**
     - Parameters:
        - url: the URL where the contraint file is located.
        - views: the map of identifier to view. All the views in the constraint file,
                 must be in this dictionary.
     */
    public init(fileURL url: URL, views: [String: UIView]) {
        self.url = url
        self.observer = FileObserver(fileToObserve: url.path)
        self.constraintBuilder = ConstraintBuilder(views: views)
    }

    // MARK: - Methods

    /**
     Builds the layout from the constraint file. Rebuilds the layout
     when the file is modified.
     
     - Parameters:
        - onChange: the closure that gets called when the constraint file is modified.
     */
    public func build(onChange: @escaping () -> Void) {
        // log
        if LayoutBuilder.showLogs { print("Building from: \(url.path)") }
        // sets the onChange closure
        observer?.onChange = { [weak self] in
            guard let self = self else { return }
            // deactivate active constraints
            NSLayoutConstraint.deactivate(self.constraints)
            self.constraints = []
            // re-build the layout
            self._build()
            // trigger the input closure
            onChange()
        }
        // start observing
        observer?.observeFile()
        // build the layout
        self._build()
    }

    /**
     Builds the layout from the constraint file.
     */
    private func _build() {
        // get the contents of the file in a string
        guard let file = try? String(contentsOf: url, encoding: .utf8) else {
            if LayoutBuilder.showLogs { print("⚠️ COULD NOT READ FILE") }
            return
        }
        // split the file string by lines
        let lines = file.components(separatedBy: .newlines)
        // read every line
        for idx in 0..<lines.count {
            // clear the constraint builder
            constraintBuilder.reset()
            do {
                // build the constraint from the
                let constraint = try constraintBuilder.build(fromLine: lines[idx])
                // add constraint to the constraints array
                constraints.append(constraint)
            } catch let error {
                // show logs
                guard LayoutBuilder.showLogs else { continue }
                if let readError = error as? ReadLineError, readError == .skip {
                    print("⚠️ Skipping line \(idx+1)")
                } else if let readError = error as? ReadLineError {
                    print("⚠️ Skipping line \(idx+1) due to an error:", readError.localizedDescription)
                } else {
                    print("⚠️ Skipping line \(idx+1) due to an error:", error)
                }
            }
        }
        // activate constraints
        NSLayoutConstraint.activate(constraints)
        // show logs
        guard LayoutBuilder.showLogs else { return }
        print("*******************************************************************************")
        print()
        for c in constraints {
            print(c)
        }
        print()
        print("*******************************************************************************")
    }

}

/// The raw constraint components from the constraint file.
private struct ConstraintComponents {

    var leftView: String = ""
    var leftAttribute: Attribute?
    var relation: Relation?
    var rightView: String?
    var rightAttribute: Attribute?
    var op: Operator?
    var constant: CGFloat?

}

/**
 Builds a constraint based on a string.
 
 The string should follow one of these formats:
 ```
 leftView.leftAnchor (= | > | <) rightView(.rightAnchor)? (+ | - ) constant
 leftView.leftAnchor (= | > | <) rightView(.rightAnchor)? * multiplier
 leftView.leftAnchor (= | > | <) constant
 ```
 */
private class ConstraintBuilder {

    // MARK: - Properties

    /// The raw representation of the constraint
    private var components = ConstraintComponents()
    /// The views that will be used to build the contraint
    private var views: [String: UIView]
    /// The entity that reads the string
    private let reader: ConstraintReader

    // MARK: - Lifecycle

    /**
     - Parameters:
        - views: the map of key: identifier and value: view. All the views in
                 the constraint file, must be in this dictionary.
     */
    init(views: [String: UIView]) {
        self.views = views
        self.reader = ConstraintReader(views: Set(views.keys))
    }

    /// Resets the components property.
    func reset() {
        components = ConstraintComponents()
    }

    // MARK: - Methods

    /**
     Builds the constraint from a string.
     
     - Parameters:
        - str: the string that represents the constraint
     */
    func build(fromLine str: String) throws -> NSLayoutConstraint {
        try reader.readLine(str, writeInto: &components)
        return try _build()
    }

    /// Builds the constraint from the `components` property.
    private func _build() throws -> NSLayoutConstraint {
        // get the left view
        guard let lhs = views[components.leftView] else {
            throw ReadLineError.invalidView(components.leftView)
        }
        // get the right view, not mandatory
        let rhs = components.rightView.flatMap({ views[$0] })
        // get the left attribute
        guard let leftAttribute = components.leftAttribute else {
            throw ReadLineError.skip
        }
        // get the relation
        guard let rawRelation = components.relation else {
            throw ReadLineError.skip
        }
        let lhsAttribute = try getAttribute(from: leftAttribute)
        let rhsAttribute = try getAttribute(from: components.rightAttribute ?? leftAttribute)
        let relation = try getRelation(from: rawRelation)

        // Edge case #1: nil second item with location for the first attribute
        // Example: view.top = 44
        if rhs == nil && ![.height, .width].contains(lhsAttribute) {
            throw ReadLineError.invalidConstraint
        }
        // Edge case #2: both attributes are in different axis
        // Example: view.lead = view.top
        guard
            (Attribute.horizontal.contains(lhsAttribute) == Attribute.horizontal.contains(rhsAttribute))
            && (Attribute.vertical.contains(lhsAttribute) == Attribute.vertical.contains(rhsAttribute))
        else {
            throw ReadLineError.invalidConstraint
        }

        let multiplier: CGFloat
        let constant: CGFloat
        switch components.op {
        case .multiply:
            multiplier = components.constant ?? 1
            constant = 0
        case .substract:
            multiplier = 1
            constant = -(components.constant ?? 0)
        case .sum, nil:
            multiplier = 1
            constant = components.constant ?? 0
        }

        return NSLayoutConstraint(
            item: lhs,
            attribute: lhsAttribute,
            relatedBy: relation,
            toItem: rhs,
            attribute: rhsAttribute,
            multiplier: multiplier,
            constant: constant
        )
    }

    // MARK: - Helper methods

    private func getAttribute(from attribute: Attribute) throws -> NSLayoutConstraint.Attribute {
        switch attribute {
        case .left:
            return .left
        case .right:
            return .right
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .width:
            return .width
        case .height:
            return .height
        case .centerX:
            return .centerX
        case .centerY:
            return .centerY
        }
    }

    private func getRelation(from relation: Relation) throws -> NSLayoutConstraint.Relation {
        switch relation {
        case .equal:
            return .equal
        case .less:
            return .lessThanOrEqual
        case .greater:
            return .greaterThanOrEqual
        }
    }

}

/**
 Reads a string and extracts the `ContraintComponents`.
 */
private struct ConstraintReader {

    let views: Set<String>

    init(views: Set<String>) {
        self.views = views
    }

    /**
     Reads the string, and writes the raw components into the passed `ConstraintComponents`.
     
     - Parameters:
        - str: the string that represents the constraint
        - components: the object that will have the constraint components.
     */
    func readLine(_ str: String, writeInto components: inout ConstraintComponents) throws {
        // check if the str starts with a comment "#" or is empty
        if str.isEmpty || str.first == "#" { throw ReadLineError.skip }
        // split the line by whitespaces
        let splits = str.split(separator: " ")
        // validate it is compacts (length = 3)
        // A. leftView.anchor  comparator  rightView(.anchor)?
        // B. leftView.anchor  comparator  constant
        // or
        // validate it is complete (length = 5)
        // C. leftView.anchor  comparator  rightView(.anchor)?  operator  constant
        guard [3, 5].contains(splits.count) else {
            throw ReadLineError.invalidFormat(str)
        }
        // 1. get the left view and anchor
        let (leftView, leftAttribute) = splitViewAndAttribute(splits[0])
        // validate view and anchor
        guard views.contains(leftView) else {
            throw ReadLineError.invalidView(leftView)
        }
        guard let lAttribute = leftAttribute.flatMap(Attribute.init) else {
            throw ReadLineError.invalidAttribute(leftAttribute)
        }
        components.leftView = leftView
        components.leftAttribute = lAttribute
        // 2. validate the comparator
        guard
            splits[1].count == 1,
            let relation = splits[1].first.flatMap(Relation.init)
        else {
            throw ReadLineError.invalidRelation(String(splits[1]))
        }
        components.relation = relation
        // 3. check if it's a dimension (width, anchor) or a view+constraint?
        // 3A. if it's a dimension (e.g. leftView.width = 100) return
        if splits.count == 3, let constant = CGFloat(splits[2]) {
            components.constant = constant
            return
        }
        // 3B. if it's not a dimension, continue
        let (rightView, rightAttribute) = splitViewAndAttribute(splits[2])
        guard views.contains(rightView) else {
            throw ReadLineError.invalidView(leftView)
        }
        // if a rightAnchor is specified, make sure it exists
        if let rAttribute = rightAttribute, Attribute(rawValue: rAttribute) == nil {
            throw ReadLineError.invalidAttribute(rAttribute)
        }
        components.rightView = rightView
        components.rightAttribute = rightAttribute.flatMap(Attribute.init)
        // exit early if no constant
        if splits.count == 3 { return }
        // 4. get the operator
        guard
            splits[3].count == 1,
            let op = splits[3].first.flatMap(Operator.init)
        else {
            throw ReadLineError.invalidOperator(String(splits[3]))
        }
        components.op = op
        // 5. get the constant
        guard let constant = CGFloat(splits[4]) else {
            throw ReadLineError.expectedOffset(String(splits[4]))
        }
        components.constant = constant
    }

    private func splitViewAndAttribute<S: StringProtocol>(_ str: S) -> (String, String?) {
        guard let splitIdx = str.firstIndex(of: ".") else {
            return (String(str), nil)
        }
        return (String(str[..<splitIdx]), String(str[str.index(after: splitIdx)...]))
    }

}

extension CGFloat {

    init?<S: StringProtocol>(_ str: S) {
        if let value = Int(str) {
            self = CGFloat(value)
        } else if let value = Double(str) {
            self = CGFloat(value)
        } else {
            return nil
        }
    }

}

private enum ReadLineError: LocalizedError, Equatable {

    /// Not really an error, used to skip the current line.
    case skip
    /// The passed constraint is logically invalid.
    case invalidConstraint
    /// The passed string is not in the expected format.
    case invalidFormat(String)
    /// The passed view is not in the [Id: View] map.
    case invalidView(String)
    /// The passed attribute is not part of Attribute.self
    case invalidAttribute(String?)
    /// The passed attribute is not part of Relation.self
    case invalidRelation(String)
    /// The passed attribute is not part of Operator.self
    case invalidOperator(String)
    /// A constant or multiplier was expected, but the string ended.
    case expectedOffset(String)

    var localizedDescription: String {
        switch self {
        case .skip:
            return ""
        case .invalidConstraint:
            return "The passed constraint is logically invalid."
        case .invalidFormat(let f):
            return "Invalid format: \(f)"
        case .invalidView(let v):
            return "View \(v) was not registered."
        case .invalidAttribute(let a):
            return "Invalid attribute: \(a ?? "")"
        case .invalidRelation(let r):
            return "Invalid relation: \(r)"
        case .invalidOperator(let o):
            return "Invalid operator: \(o)"
        case .expectedOffset(let o):
            return "Expected an offset, but got \"\(o)\" instead."
        }
    }

}

private enum Relation: Character {

    case equal = "="
    case less = "<"
    case greater = ">"

}

private enum Operator: Character {

    case sum = "+"
    case substract = "-"
    case multiply = "*"

}

private enum Attribute: String {

    // MARK: - Cases

    case top = "top"
    case bottom = "bottom"
    case left = "left"
    case right = "right"
    case leading = "lead"
    case trailing = "trail"

    case width = "width"
    case height = "height"

    case centerX = "centerX"
    case centerY = "centerY"

    // MARK: - Properties

    static let horizontal: Set<NSLayoutConstraint.Attribute> = [
        .left, .right, .leading, .trailing, .centerX
    ]

    static let vertical: Set<NSLayoutConstraint.Attribute> = [
        .top, .bottom, .centerY
    ]

}
