//
//  Size.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import CoreGraphics

public struct Size: Equatable {
  public let width: Value
  public let height: Value
  
  public static let zero = Size(0, 0)
  
  public static func fixed(_ width: CGFloat, _ height: CGFloat) -> Size {
    return Size(width: .fixed(width), height: .fixed(height))
  }
  
  public static func scalable(_ width: CGFloat, _ height: CGFloat) -> Size {
    return Size(width: .scalable(width), height: .scalable(height))
  }
  
  public static func scalable(_ scalable: CGFloat) -> Value {
    return Value.init(scalable: scalable, fixed: 0)
  }
  
  public init(_ width: CGFloat, _ height: CGFloat) {
    self.width = Value(width)
    self.height = Value(height)
  }
  
  public init(scalableWidth: CGFloat, fixedWidth: CGFloat, scalableHeight: CGFloat, fixedHeight: CGFloat) {
    self.width = Value(scalable: scalableWidth, fixed: fixedWidth)
    self.height = Value(scalable: scalableHeight, fixed: fixedHeight)
  }
  
  public init(width: Value, height: Value) {
    self.width = width
    self.height = height
  }
  
  public func scale(by multiplier: CGFloat) -> CGSize {
    return CGSize(
      width: self.width.scale(by: multiplier),
      height: self.height.scale(by: multiplier)
    )
  }
  
  public static func * (lhs: Size, rhs: CGFloat) -> Size {
    return Size(width: lhs.width * rhs, height: lhs.height * rhs)
  }
  
  public static func + (lhs: Size, rhs: Size) -> Size {
    return Size(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }
  
  public static func / (lhs: Size, rhs: CGFloat) -> Size {
    return Size(width: lhs.width / rhs, height: lhs.height / rhs)
  }
  
  public static func == (lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
  }
}
