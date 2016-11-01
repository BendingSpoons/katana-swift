//
//  PlasticView.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

private enum ConstraintX {
  case none, left, right, centerX, width
}

private enum ConstraintY {
  case none, top, bottom, centerY, height
}

public class PlasticView {
  public let key: String
  
  public private(set) var frame: CGRect
  private let multiplier: CGFloat
  private(set) var absoluteOrigin: CGPoint
  private unowned let hierarchyManager: HierarchyManager
  
  private var oldestConstraintX = ConstraintX.none
  private var newestConstraintX = ConstraintX.none
  private var oldestConstraintY = ConstraintY.none
  private var newestConstraintY = ConstraintY.none
  
  private var constraintX: ConstraintX {
    get {
      return newestConstraintX
    }
    
    set(newValue) {
      oldestConstraintX = newestConstraintX
      newestConstraintX = newValue
    }
  }
  
  private var constraintY: ConstraintY {
    get {
      return newestConstraintY
    }
    
    set(newValue) {
      oldestConstraintY = newestConstraintY
      newestConstraintY = newValue
    }
  }

  init(hierarchyManager: HierarchyManager, key: String, multiplier: CGFloat, frame: CGRect) {
    self.key = key
    self.frame = frame
    self.absoluteOrigin = frame.origin
    self.multiplier = multiplier
    self.hierarchyManager = hierarchyManager
  }

  
  func scaleValue(_ value: Value) -> CGFloat {
    return value.scale(by: multiplier)
  }

  
  private func updateHeight(_ newValue: CGFloat) -> Void {
    self.frame.size.height = newValue
  }
  
  private func updateWidth(_ newValue: CGFloat) -> Void {
    self.frame.size.width = newValue
  }
  
  private func updateX(_ newValue: CGFloat) -> Void {
    let relativeValue = self.hierarchyManager.getXCoordinate(newValue, inCoordinateSystemOfParentOfKey: self.key)
    self.frame.origin.x = relativeValue
    self.absoluteOrigin.x = newValue
  }
  
  private func updateY(_ newValue: CGFloat) -> Void {
    let relativeValue = self.hierarchyManager.getYCoordinate(newValue, inCoordinateSystemOfParentOfKey: self.key)
    self.frame.origin.y = relativeValue
    self.absoluteOrigin.y = newValue
  }

  
  public var height: Value {
    get {
      return .fixed(self.frame.size.height)
    }
    
    set(newValue) {
      setHeight(newValue)
    }
  }
  
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

  
  public var width: Value {
    get {
      return .fixed(self.frame.size.width)
    }
    
    set(newValue) {
      setWidth(newValue)
    }
  }
  
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

  
  public var bottom: Anchor {
    get {
      return Anchor(kind: .bottom, view: self)
    }
    
    set(newValue) {
      setBottom(newValue)
    }
  }
  
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

  
  public var top: Anchor {
    get {
      return Anchor(kind: .top, view: self)
    }
    
    set(newValue) {
      setTop(newValue)
    }
  }
  
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

  
  public var right: Anchor {
    get {
      return Anchor(kind: .right, view: self)
    }
    
    set(newValue) {
      setRight(newValue)
    }
  }
  
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

  
  public var left: Anchor {
    get {
      return Anchor(kind: .left, view: self)
    }
    
    set(newValue) {
      setLeft(newValue)
    }
  }
  
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

  
  public var centerX: Anchor {
    get {
      return Anchor(kind: .centerX, view: self)
    }
    
    set(newValue) {
      setCenterX(newValue)
    }
  }
  
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

  
  public var centerY: Anchor {
    get {
      return Anchor(kind: .centerY, view: self)
    }
    
    set(newValue) {
      setCenterY(newValue)
    }
  }
  
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
