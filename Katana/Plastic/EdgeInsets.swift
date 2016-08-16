//
//  EdgeInsets.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct EdgeInsets: Equatable {
  let top: Value
  let left: Value
  let bottom: Value
  let right: Value
  
  static let zero = EdgeInsets(0, 0, 0, 0)
  
  init(_ top: Float, _ left: Float, _ bottom: Float, _ right: Float) {
    self.top = Value(top)
    self.left = Value(left)
    self.bottom = Value(bottom)
    self.right = Value(right)
  }
  
  init(scalableTop: Float, fixedTop: Float, scalableLeft: Float, fixedLeft: Float, scalableBottom: Float, fixedBottom: Float, scalableRight: Float, fixedRight: Float) {
    self.top = Value(scalable: scalableTop, fixed: fixedTop)
    self.left = Value(scalable: scalableLeft, fixed: fixedLeft)
    self.bottom = Value(scalable: scalableBottom, fixed: fixedBottom)
    self.right = Value(scalable: scalableRight, fixed: fixedRight)
  }
  
  init(top: Value, left: Value, bottom: Value, right: Value) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }
  
  public func scale(_ multiplier: Float) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: CGFloat(self.top.scale(multiplier)),
      left: CGFloat(self.left.scale(multiplier)),
      bottom: CGFloat(self.bottom.scale(multiplier)),
      right: CGFloat(self.right.scale(multiplier))
    )
  }
  
  public static func *(lhs: EdgeInsets, rhs: Float) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top * rhs,
      left: lhs.left * rhs,
      bottom: lhs.bottom * rhs,
      right: lhs.right * rhs
    )
  }
  
  public static func +(lhs: EdgeInsets, rhs: EdgeInsets) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top + rhs.top,
      left: lhs.left + rhs.left,
      bottom: lhs.bottom + rhs.bottom,
      right: lhs.right + rhs.right
    )
  }
  
  public static func /(lhs: EdgeInsets, rhs: Float) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top / rhs,
      left: lhs.left / rhs,
      bottom: lhs.bottom / rhs,
      right: lhs.right / rhs
    )
  }
  
  public static func ==(lhs: EdgeInsets, rhs: EdgeInsets) -> Bool {
    return lhs.top == rhs.top &&
      lhs.left == rhs.left &&
      lhs.bottom == rhs.bottom &&
      lhs.right == rhs.right
  }
}
