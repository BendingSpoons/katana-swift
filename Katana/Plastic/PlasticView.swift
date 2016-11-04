//
//  PlasticView.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

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
 
 This abstraction has been introduced to avoid to deal directly with `UIView` instances in the Katana
 world. This allows us to implement some optimizations behinde the scenes (e.g., caching)
*/
public class PlasticView {
  
  /**
    They of the instance, this is the same defined in the
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
    A manager that can be used to emulate UIKit capabilities
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
   
   - parameter hierarchyManager: the hierarchy manager to use to emulate UIKit capabilities
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
  private func updateHeight(_ newValue: CGFloat) -> Void {
    self.frame.size.height = newValue
  }

  /**
   Updates the `frame` width value
   
   - parameter newValue: the new value to assig
  */
  private func updateWidth(_ newValue: CGFloat) -> Void {
    self.frame.size.width = newValue
  }
  
  /**
   Updates the `frame` X origin value
   
   - parameter newValue: the new value to assig
  */
  private func updateX(_ newValue: CGFloat) -> Void {
    let relativeValue = self.hierarchyManager.getXCoordinate(newValue, inCoordinateSystemOfParentOfKey: self.key)
    self.frame.origin.x = relativeValue
    self.absoluteOrigin.x = newValue
  }

  /**
   Updates the `frame` Y origin value
   
   - parameter newValue: the new value to assig
  */
  private func updateY(_ newValue: CGFloat) -> Void {
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
      setHeight(newValue)
    }
  }

  /**
   Sets a new height for the instance
   
   - parameter value: the new height
  */
  private func setHeight(_ value: Value) {
    self.constraintY = .height
    
    let newHeight = max(scaleValue(value), 0)
    var newTop = self.top.coordinate
    
    if oldestConstraintY == .bottom {
      newTop = self.bottom.coordinate - newHeight
    
    } else if oldestConstraintY == .centerY {
      newTop = self.centerY.coordinate - newHeight / 2.0
    }
    
    self.updateY(newTop)
    self.updateHeight(newHeight)
  }

  
  /// The width of the instance
  public var width: Value {
    get {
      return .fixed(self.frame.size.width)
    }
    
    set(newValue) {
      setWidth(newValue)
    }
  }
  
  /**
   Sets a new width for the instance
   
   - parameter value: the new width
  */
  private func setWidth(_ value: Value) {
    self.constraintX = .width
    
    let newWidth = max(scaleValue(value), 0)
    var newLeft = self.left.coordinate
    
    if self.oldestConstraintX == .right {
      newLeft = self.right.coordinate - newWidth
    
    } else if self.oldestConstraintX == .centerX {
      newLeft = self.centerX.coordinate - newWidth / 2.0
    }
    
    self.updateX(newLeft)
    self.updateWidth(newWidth)
  }

  /**
   The bottom anchor of the instance.
   
   Setting is value has the same effect of invoking `setBottom(_:offset:)` with an offset equal to `.zero`
  */
  public var bottom: Anchor {
    get {
      return Anchor(kind: .bottom, view: self)
    }
    
    set(newValue) {
      setBottom(newValue)
    }
  }

  /**
   Sets the view's bottom edge position equal to the given anchor
   
   - parameter anchor: the anchor
   - parameter offset: an optional offset to use with respect to the anchor. The default value is `.zero`
  */
  public func setBottom(_ anchor: Anchor, offset: Value = Value.zero) -> Void {
    self.constraintY = .bottom
    
    let newBottom = anchor.coordinate + scaleValue(offset)
    var newHeight = scaleValue(self.height)
    
    if oldestConstraintY == .top {
      newHeight = max(newBottom - self.top.coordinate, 0)
    
    } else if oldestConstraintY == .centerY {
      newHeight = max(2 * (newBottom - self.centerY.coordinate), 0)
    }
    
    self.updateY(newBottom - newHeight)
    self.updateHeight(newHeight)
  }

  /**
   The top anchor of the instance.
   
   Setting is value has the same effect of invoking `setTop(_:offset:)` with an offset equal to `.zero`
  */
  public var top: Anchor {
    get {
      return Anchor(kind: .top, view: self)
    }
    
    set(newValue) {
      setTop(newValue)
    }
  }

  /**
   Sets the view's top edge position equal to the given anchor
   
   - parameter anchor: the anchor
   - parameter offset: an optional offset to use with respect to the anchor. The default value is `.zero`
  */
  public func setTop(_ anchor: Anchor, offset: Value = Value.zero) -> Void {
    self.constraintY = .top

    let newTop = anchor.coordinate + scaleValue(offset)
    var newHeight = scaleValue(self.height)
    
    if self.constraintY == .bottom {
      newHeight = max(self.bottom.coordinate - newTop, 0)
    
    } else if self.constraintY == .centerY {
      newHeight = max(2.0 * (self.centerY.coordinate - newTop), 0.0)
    }
    
    self.updateY(newTop)
    self.updateHeight(newHeight)
  }

  /**
   The right anchor of the instance.
   
   Setting is value has the same effect of invoking `setRight(_:offset:)` with an offset equal to `.zero`
  */
  public var right: Anchor {
    get {
      return Anchor(kind: .right, view: self)
    }
    
    set(newValue) {
      setRight(newValue)
    }
  }
  
  /**
   Sets the view's right edge position equal to the given anchor
   
   - parameter anchor: the anchor
   - parameter offset: an optional offset to use with respect to the anchor. The default value is `.zero`
  */
  public func setRight(_ anchor: Anchor, offset: Value = Value.zero) -> Void {
    self.constraintX = .right
    
    let newRight = anchor.coordinate + scaleValue(offset)
    var newWidth = scaleValue(self.width)
    
    if self.oldestConstraintX == .left {
      newWidth = max(newRight - self.left.coordinate, 0.0)
    
    } else if self.oldestConstraintX == .centerX {
      newWidth = max(2.0 * (newRight - self.centerX.coordinate), 0.0)
    }
    
    self.updateX(newRight - newWidth)
    self.updateWidth(newWidth)
  }

  
  /**
   The left anchor of the instance.
   
   Setting is value has the same effect of invoking `setLeft(_:offset:)` with an offset equal to `.zero`
  */
  public var left: Anchor {
    get {
      return Anchor(kind: .left, view: self)
    }
    
    set(newValue) {
      setLeft(newValue)
    }
  }
  
  /**
   Sets the view's left edge position equal to the given anchor
   
   - parameter anchor: the anchor
   - parameter offset: an optional offset to use with respect to the anchor. The default value is `.zero`
  */
  public func setLeft(_ anchor: Anchor, offset: Value = Value.zero) -> Void {
    self.constraintX = .left
    
    let newLeft = anchor.coordinate + scaleValue(offset)
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

  /**
   The horizontal center anchor of the instance.
   
   Setting is value has the same effect of invoking `setCenterX(_:offset:)` with an offset equal to `.zero`
  */
  public var centerX: Anchor {
    get {
      return Anchor(kind: .centerX, view: self)
    }
    
    set(newValue) {
      setCenterX(newValue)
    }
  }
  
  /**
   Sets the view's horizontal center position equal to the given anchor
   
   - parameter anchor: the anchor
   - parameter offset: an optional offset to use with respect to the anchor. The default value is `.zero`
  */
  public func setCenterX(_ anchor: Anchor, offset: Value = Value.zero) -> Void {
    self.constraintX = .centerX
    
    let newCenterX = anchor.coordinate + scaleValue(offset)
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

  /**
   The vertical center anchor of the instance.
   
   Setting is value has the same effect of invoking `setCenterY(_:offset:)` with an offset equal to `.zero`
  */
  public var centerY: Anchor {
    get {
      return Anchor(kind: .centerY, view: self)
    }
    
    set(newValue) {
      setCenterY(newValue)
    }
  }
  
  /**
   Sets the view's vertical center position equal to the given anchor
   
   - parameter anchor: the anchor
   - parameter offset: an optional offset to use with respect to the anchor. The default value is `.zero`
  */
  public func setCenterY(_ anchor: Anchor, offset: Value = Value.zero) -> Void {
    self.constraintY = .centerY
    
    let newCenterY = anchor.coordinate + scaleValue(offset)
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
