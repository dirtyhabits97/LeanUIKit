//
//  LayoutBuilderTestCase.swift
//  LeanUIKit
//
//  Created by Gonzalo Reyes Huertas on 9/21/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import XCTest
@testable import LeanUIKit

class LayoutBuilderTestCase: XCTestCase {
    
    let bundle = Bundle(for: LayoutBuilderTestCase.self)
    var builder: LayoutBuilder!
    
    override class func setUp() {
        LayoutBuilder.showLogs = false
    }
    
    override func tearDown() {
        builder = nil
    }
    
    func testHorizontalConstraints() {
        let view = UIView()
        let label = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let label4 = UILabel()
        let label5 = UILabel()
        view.addSuviews([label, label2, label3, label4, label5])
        builder = LayoutBuilder(
            fileURL: bundle.url(forResource: "horizontal_constraints", withExtension: nil)!,
            views: [
                "s": view,
                "l": label,
                "l2": label2,
                "l3": label3,
                "l4": label4,
                "l5": label5,
            ]
        )
        builder.build { }
        // these constraints are equivalent to the ones in horizontal_constraints
        // if the raw file is modified, this array should be modified as well
        let constraints = [
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label2.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            label2.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            label3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            label3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            label4.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 16),
            label4.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -16),
            label5.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        for (lhs, rhs) in zip(builder.constraints, constraints) {
            XCTAssertTrue(
                compare(lhs, rhs),
                "\n\(lhs)\n\(rhs)"
            )
        }
    }
    
    func testVerticalConstraints() {
        let view = UIView()
        let label = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        view.addSuviews([label, label2, label3])
        builder = LayoutBuilder(
            fileURL: bundle.url(forResource: "vertical_constraints", withExtension: nil)!,
            views: [
                "s": view,
                "l": label,
                "l2": label2,
                "l3": label3
            ]
        )
        builder.build { }
        // these constraints are equivalent to the ones in horizontal_constraints
        // if the raw file is modified, this array should be modified as well
        let constraints = [
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            label2.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 16),
            label2.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16),
            label3.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        for (lhs, rhs) in zip(builder.constraints, constraints) {
            XCTAssertTrue(
                compare(lhs, rhs),
                "\n\(lhs)\n\(rhs)"
            )
        }
    }
    
    func testDimensionConstraints() {
        let view = UIView()
        let label = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        view.addSuviews([label, label2, label3])
        builder = LayoutBuilder(
            fileURL: bundle.url(forResource: "dimension_constraints", withExtension: nil)!,
            views: [
                "s": view,
                "l": label,
                "l2": label2,
                "l3": label3
            ]
        )
        builder.build { }
        // these constraints are equivalent to the ones in horizontal_constraints
        // if the raw file is modified, this array should be modified as well
        let constraints = [
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100),
            label2.widthAnchor.constraint(equalTo: label.widthAnchor),
            label3.widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 0.5),
            label.heightAnchor.constraint(equalTo: label.widthAnchor),
            label2.heightAnchor.constraint(equalToConstant: 44),
            label3.heightAnchor.constraint(equalTo: label.heightAnchor, multiplier: 0.5),
        ]
        for (lhs, rhs) in zip(builder.constraints, constraints) {
            XCTAssertTrue(
                compare(lhs, rhs),
                "\n\(lhs)\n\(rhs)"
            )
        }
    }
    
    func testConstraintErrors() {
        LayoutBuilder.showLogs = true
        let view = UIView()
        let label = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        view.addSuviews([label, label2, label3])
        builder = LayoutBuilder(
            fileURL: bundle.url(forResource: "error_constraints", withExtension: nil)!,
            views: [
                "s": view,
                "l": label,
                "l2": label2,
                "l3": label3
            ]
        )
        builder.build { }
        XCTAssertTrue(builder.constraints.isEmpty)
        LayoutBuilder.showLogs = false
    }

}

private extension UIView {
    
    func addSuviews(_ views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    
}

private func compare(
    _ lhs: NSLayoutConstraint,
    _ rhs: NSLayoutConstraint
) -> Bool {
    return lhs.firstItem === rhs.firstItem
        && lhs.secondItem === rhs.secondItem
        && lhs.firstAttribute == rhs.firstAttribute
        && lhs.secondAttribute == rhs.secondAttribute
        && lhs.relation == rhs.relation
        && lhs.constant == rhs.constant
        && lhs.multiplier == rhs.multiplier
}
