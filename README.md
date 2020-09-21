# LeanUIKit

UIKit based framework with helpers that reduce boilerplate code and help to better configure views.

## Table of Contents
* [Requirements](#Requirements)
* [Usage](#Usage)
* [Author](#Author)

## Requirements
* iOS 11.0+
* Xcode 11+
* Swift 5.1+

## Usage

### Helpers

Check the jazzy docs to get an idea of the helpers in this project.

### Layout Builder

Create a constraints file in your project. You can look at:
* Tests/Layout/dimension_constraints
* Tests/Layout/horizontal_constraints
* Tests/Layout/vertical_constraints

Avoid the constraint mistakes in:
* Tests/Layout/error_constraints

Pass the `URL` to your constraint file (not the one in the `Bundle`, but to the file in your machine):

```swift
let builder = LayoutBuilder(fileURL: urlToMyFile, views: ...)
builder.build(onChange: { [weak self] in
    self?.parentView.updateConstraintsIfNeeded()
})
```

Whenever you save your file, the constraints will be updated.

## Author

* (Gonzalo Reyes Huertas)[https://github.com/dirtyhabits97]
