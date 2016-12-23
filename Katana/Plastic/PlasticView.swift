//
//  PlasticView.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import CoreGraphics

/// Enum that represents a constraint in the X axis
private enum ConstraintX {
  case none, left, right, centerX, width
}

/// Enum that represents a constraint in the Y axis
private enum ConstraintY {
  case none, top, bottom, centerY, height
}

/**
 This class basically acts as an abstraction over views created through Katana.
 The idea is that Plastic will create a `PlasticView` for each node description returned by
 `childrenDescriptions(props:state:update:dispatch:)`. You can then apply Plastic methods
 over the instances of `PlasticView` and achieve the desidered layout.
 
 This abstraction has been introduced to avoid to deal directly with `UIView` or 'NSView' instances in the Katana
 world. This allows us to implement some optimizations behinde the scenes (e.g., caching).
*/
public class PlasticView {

  /**
    Key of the instance, this is the same defined in the
    corresponded node description properties
  */
  public let key: String

  /// The current frame of the instance. It can be changed by applying Plastic methods
  public private(set) var frame: CGRect

  /// The plastic multiplier that will be used to scale the values
  private let multiplier: CGFloat

  /// The frame of the instance in the native view coordinate system
  private(set) var absoluteOrigin: CGPoint

  /**
    A manager that can be used to emulate UIKit/AppKit capabilities
    - seeAlso: `CoordinateConvertible`
  */
  private unowned let hierarchyManager: CoordinateConvertible

  /// The X constraint related to the previous plastic method
  private var oldestConstraintX = ConstraintX.none

  /// The X constraint related to the last plastic method
  private var newestConstraintX = ConstraintX.none

  /// The Y constraint related to the previous plastic method
  private var oldestConstraintY = ConstraintY.none

  /// The Y constraint related to the last plastic method
  private var newestConstraintY = ConstraintY.none

  /// The current X constraint
  private var constraintX: ConstraintX {
    get {
      return newestConstraintX
    }

    set(newValue) {
      oldestConstraintX = newestConstraintX
      newestConstraintX = newValue
    }
  }

  /// The current Y constraint
  private var constraintY: ConstraintY {
    get {
      return newestConstraintY
    }

    set(newValue) {
      oldestConstraintY = newestConstraintY
      newestConstraintY = newValue
    }
  }

  /**
   Creates an instance of `PlasticView` with the given parameters
   
   - parameter hierarchyManager: the hierarchy manager to use to emulate UIKit/AppKit capabilities
   - parameter key:              the key of the node description with which the instance will be associated to
   - parameter multiplier:       the plastic multiplier to use
   - parameter frame:            the initial frame of the instance
   - returns: a valid instance of `PlasticView`
  */
  init(hierarchyManager: CoordinateConvertible, key: String, multiplier: CGFloat, frame: CGRect) {
    self.key = key
    self.frame = frame
    self.absoluteOrigin = frame.origin
    self.multiplier = multiplier
    self.hierarchyManager = hierarchyManager
  }

  /**
   Scales a value by using the multiplier defined in the `init(hierarchyManager:key:multiplier:frame:)` method
   
   - parameter value: the value to scale
   - returns: the scaled value
  */
  func scaleValue(_ value: Value) -> CGFloat {
    return value.scale(by: multiplier)
  }

  /**
   Updates the `frame` height value
   
   - parameter newValue: the new value to assig
  */
  private func updateHeight(_ newValue: CGFloat) {
    self.frame.size.height = newValue
  }

  /**
   Updates the `frame` width value
   
   - parameter newValue: the new value to assig
  */
  private func updateWidth(_ newValue: CGFloat) {
    self.frame.size.width = newValue
  }

  /**
   Updates the `frame` X origin value
   
   - parameter newValue: the new value to assig
  */
  private func updateX(_ newValue: CGFloat) {
    let relativeValue = self.hierarchyManager.getXCoordinate(newValue, inCoordinateSystemOfParentOfKey: self.key)
    self.frame.origin.x = relativeValue
    self.absoluteOrigin.x = newValue
  }

  /**
   Updates the `frame` Y origin value
   
   - parameter newValue: the new value to assig
  */
  private func updateY(_ newValue: CGFloat) {
    let relativeValue = self.hierarchyManager.getYCoordinate(newValue, inCoordinateSystemOfParentOfKey: self.key)
    self.frame.origin.y = relativeValue
    self.absoluteOrigin.y = newValue
  }

  /// The height of the instance
  public var height: Value {
    get {
      return .fixed(self.frame.size.height)
    }

    set(newValue) {
      self.constraintY = .height

      let newHeight = max(scaleValue(newValue), 0)
      var newTop = self.top.coordinate

      if oldestConstraintY == .bottom {
        newTop = self.bottom.coordinate - newHeight

      } else if oldestConstraintY == .centerY {
        newTop = self.centerY.coordinate - newHeight / 2.0
      }

      self.updateY(newTop)
      self.updateHeight(newHeight)
    }
  }

  /// The width of the instance
  public var width: Value {
    get {
      return .fixed(self.frame.size.width)
    }

    set(newValue) {
      self.constraintX = .width

      let newWidth = max(scaleValue(newValue), 0)
      var newLeft = self.left.coordinate

      if self.oldestConstraintX == .right {
        newLeft = self.right.coordinate - newWidth

      } else if self.oldestConstraintX == .centerX {
        newLeft = self.centerX.coordinate - newWidth / 2.0
      }

      self.updateX(newLeft)
      self.updateWidth(newWidth)
    }
  }

  /**
   The bottom anchor of the instance.
   
   Setting its value sets the view's bottom edge position equal to the given anchor
  */
  public var bottom: Anchor {
    get {
      return Anchor(kind: .bottom, view: self)
    }

    set(newValue) {
      self.constraintY = .bottom

      let newBottom = newValue.coordinate
      var newHeight = scaleValue(self.height)

      if oldestConstraintY == .top {
        newHeight = max(newBottom - self.top.coordinate, 0)

      } else if oldestConstraintY == .centerY {
        newHeight = max(2 * (newBottom - self.centerY.coordinate), 0)
      }

      self.updateY(newBottom - newHeight)
      self.updateHeight(newHeight)
    }
  }

  /**
   The top anchor of the instance.
   
   Setting its value sets the view's top edge position equal to the given anchor
  */
  public var top: Anchor {
    get {
      return Anchor(kind: .top, view: self)
    }

    set(newValue) {
      self.constraintY = .top

      let newTop = newValue.coordinate
      var newHeight = scaleValue(self.height)

      if self.constraintY == .bottom {
        newHeight = max(self.bottom.coordinate - newTop, 0)

      } else if self.constraintY == .centerY {
        newHeight = max(2.0 * (self.centerY.coordinate - newTop), 0.0)
      }

      self.updateY(newTop)
      self.updateHeight(newHeight)
    }
  }

  /**
   The right anchor of the instance.
   
   Setting its value sets the view's right edge position equal to the given anchor
  */
  public var right: Anchor {
    get {
      return Anchor(kind: .right, view: self)
    }

    set(newValue) {
      self.constraintX = .right

      let newRight = newValue.coordinate
      var newWidth = scaleValue(self.width)

      if self.oldestConstraintX == .left {
        newWidth = max(newRight - self.left.coordinate, 0.0)

      } else if self.oldestConstraintX == .centerX {
        newWidth = max(2.0 * (newRight - self.centerX.coordinate), 0.0)
      }

      self.updateX(newRight - newWidth)
      self.updateWidth(newWidth)
    }
  }

  /**
   The left anchor of the instance.
   
   Setting its value sets the view's left edge position equal to the given anchor
  */
  public var left: Anchor {
    get {
      return Anchor(kind: .left, view: self)
    }

    set(newValue) {
      self.constraintX = .left

      let newLeft = newValue.coordinate
      var newWidth = scaleValue(self.width)

      if self.oldestConstraintX == .right {
        newWidth = max(self.right.coordinate - newLeft, 0)

      } else if self.oldestConstraintX == .centerX {
        newWidth = max(2.0 * (self.centerX.coordinate - newLeft), 0.0)
      }

      // update coords
      self.updateX(newLeft)
      self.updateWidth(newWidth)
    }
  }

  /**
   The horizontal center anchor of the instance.
   
   Setting its value sets the view's horizontal center position equal to the given anchor
  */
  public var centerX: Anchor {
    get {
      return Anchor(kind: .centerX, view: self)
    }

    set(newValue) {
      self.constraintX = .centerX

      let newCenterX = newValue.coordinate
      var newWidth = scaleValue(self.width)

      if self.oldestConstraintX == .left {
        newWidth = max(2.0 * (newCenterX - self.left.coordinate), 0.0)

      } else if self.oldestConstraintX == .right {
        newWidth = max(2.0 * (self.right.coordinate - newCenterX), 0.0)
      }

      // update coords
      self.updateX(newCenterX - newWidth / 2.0)
      self.updateWidth(newWidth)
    }
  }

  /**
   The vertical center anchor of the instance.
   
   Setting its value sets the view's vertical center position equal to the given anchor
  */
  public var centerY: Anchor {
    get {
      return Anchor(kind: .centerY, view: self)
    }

    set(newValue) {
      self.constraintY = .centerY

      let newCenterY = newValue.coordinate
      var newHeight = scaleValue(self.height)

      if self.oldestConstraintY == .top {
        newHeight = max(2.0 * (newCenterY - self.top.coordinate), 0.0)

      } else if self.oldestConstraintY == .bottom {
        newHeight = max(2.0 * (self.bottom.coordinate - newCenterY), 0.0)
      }

      // update coords
      self.updateY(newCenterY - newHeight / 2.0)
      self.updateHeight(newHeight)
    }
  }

  /// The size of the instance
  public var size: Size {
    get {
      return .fixed(self.frame.width, self.frame.height)
    }

    set(newValue) {
      self.height = newValue.height
      self.width = newValue.width
    }
  }
}
