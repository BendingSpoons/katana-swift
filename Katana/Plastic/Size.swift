//
//  Size.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct Size: Equatable {
  let width: Value
  let height: Value
  
  static let zero = Size(0, 0)
  
  init(_ width: CGFloat, _ height: CGFloat) {
    self.width = Value(width)
    self.height = Value(height)
  }
  
  init(scalableWidth: CGFloat, fixedWidth: CGFloat, scalableHeight: CGFloat, fixedHeight: CGFloat) {
    self.width = Value(scalable: scalableWidth, fixed: fixedWidth)
    self.height = Value(scalable: scalableHeight, fixed: fixedHeight)
  }
  
  init(width: Value, height: Value) {
    self.width = width
    self.height = height
  }
  
  public func scale(_ multiplier: CGFloat) -> CGSize {
    return CGSize(
      width: self.width.scale(multiplier),
      height: self.height.scale(multiplier)
    )
  }
  
  public static func *(lhs: Size, rhs: CGFloat) -> Size {
    return Size(width: lhs.width * rhs, height: lhs.height * rhs)
  }
  
  public static func +(lhs: Size, rhs: Size) -> Size {
    return Size(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }
  
  public static func /(lhs: Size, rhs: CGFloat) -> Size {
    return Size(width: lhs.width / rhs, height: lhs.height / rhs)
  }
  
  public static func ==(lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
  }
}
