//
//  EdgeInsets.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import CoreGraphics

public struct EdgeInsets: Equatable {
  public let top: Value
  public let left: Value
  public let bottom: Value
  public let right: Value
  
  public static let zero = EdgeInsets(0, 0, 0, 0)
  
  public static func fixed(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> EdgeInsets {
    return EdgeInsets(top: .fixed(top), left: .fixed(left), bottom: .fixed(bottom), right: .fixed(right))
  }
  
  public static func scalable(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> EdgeInsets {
    return EdgeInsets(top: .scalable(top), left: .scalable(left), bottom: .scalable(bottom), right: .scalable(right))
  }
  
  public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
    self.top = Value(top)
    self.left = Value(left)
    self.bottom = Value(bottom)
    self.right = Value(right)
  }
  
  public init(scalableTop: CGFloat,
                 fixedTop: CGFloat,
             scalableLeft: CGFloat,
                fixedLeft: CGFloat,
           scalableBottom: CGFloat,
              fixedBottom: CGFloat,
            scalableRight: CGFloat,
               fixedRight: CGFloat) {
    
    self.top = Value(scalable: scalableTop, fixed: fixedTop)
    self.left = Value(scalable: scalableLeft, fixed: fixedLeft)
    self.bottom = Value(scalable: scalableBottom, fixed: fixedBottom)
    self.right = Value(scalable: scalableRight, fixed: fixedRight)
  }
  
  public init(top: Value, left: Value, bottom: Value, right: Value) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }
  
  public func scale(by multiplier: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: self.top.scale(by: multiplier),
      left: self.left.scale(by: multiplier),
      bottom: self.bottom.scale(by: multiplier),
      right: self.right.scale(by: multiplier)
    )
  }
  
  public static func * (lhs: EdgeInsets, rhs: CGFloat) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top * rhs,
      left: lhs.left * rhs,
      bottom: lhs.bottom * rhs,
      right: lhs.right * rhs
    )
  }
  
  public static func + (lhs: EdgeInsets, rhs: EdgeInsets) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top + rhs.top,
      left: lhs.left + rhs.left,
      bottom: lhs.bottom + rhs.bottom,
      right: lhs.right + rhs.right
    )
  }
  
  public static func / (lhs: EdgeInsets, rhs: CGFloat) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top / rhs,
      left: lhs.left / rhs,
      bottom: lhs.bottom / rhs,
      right: lhs.right / rhs
    )
  }
  
  public static func == (lhs: EdgeInsets, rhs: EdgeInsets) -> Bool {
    return lhs.top == rhs.top &&
      lhs.left == rhs.left &&
      lhs.bottom == rhs.bottom &&
      lhs.right == rhs.right
  }
}
