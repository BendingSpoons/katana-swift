//
//  PlasticEdgeInsets.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct PlasticEdgeInsets: Equatable {
  let top: PlasticValue
  let left: PlasticValue
  let bottom: PlasticValue
  let right: PlasticValue
  
  static let zero = PlasticEdgeInsets(0, 0, 0, 0)
  
  init(_ top: Float, _ left: Float, _ bottom: Float, _ right: Float) {
    self.top = PlasticValue(top)
    self.left = PlasticValue(left)
    self.bottom = PlasticValue(bottom)
    self.right = PlasticValue(right)
  }
  
  init(scalableTop: Float, fixedTop: Float, scalableLeft: Float, fixedLeft: Float, scalableBottom: Float, fixedBottom: Float, scalableRight: Float, fixedRight: Float) {
    self.top = PlasticValue(scalable: scalableTop, fixed: fixedTop)
    self.left = PlasticValue(scalable: scalableLeft, fixed: fixedLeft)
    self.bottom = PlasticValue(scalable: scalableBottom, fixed: fixedBottom)
    self.right = PlasticValue(scalable: scalableRight, fixed: fixedRight)
  }
  
  init(top: PlasticValue, left: PlasticValue, bottom: PlasticValue, right: PlasticValue) {
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
  
  public static func *(lhs: PlasticEdgeInsets, rhs: Float) -> PlasticEdgeInsets {
    return PlasticEdgeInsets(
      top: lhs.top * rhs,
      left: lhs.left * rhs,
      bottom: lhs.bottom * rhs,
      right: lhs.right * rhs
    )
  }
  
  public static func +(lhs: PlasticEdgeInsets, rhs: PlasticEdgeInsets) -> PlasticEdgeInsets {
    return PlasticEdgeInsets(
      top: lhs.top + rhs.top,
      left: lhs.left + rhs.left,
      bottom: lhs.bottom + rhs.bottom,
      right: lhs.right + rhs.right
    )
  }
  
  public static func /(lhs: PlasticEdgeInsets, rhs: Float) -> PlasticEdgeInsets {
    return PlasticEdgeInsets(
      top: lhs.top / rhs,
      left: lhs.left / rhs,
      bottom: lhs.bottom / rhs,
      right: lhs.right / rhs
    )
  }
  
  public static func ==(lhs: PlasticEdgeInsets, rhs: PlasticEdgeInsets) -> Bool {
    return lhs.top == rhs.top &&
      lhs.left == rhs.left &&
      lhs.bottom == rhs.bottom &&
      lhs.right == rhs.right
  }
}
