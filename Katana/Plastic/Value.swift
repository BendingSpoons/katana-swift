//
//  Value.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct Value: Equatable {
  let scalable: CGFloat
  let fixed: CGFloat
  
  var unscaledValue: CGFloat {
    return scalable + fixed
  }
  
  static let zero = Value(0)
  
  static func fixed(_ fixed: CGFloat) -> Value {
    return Value.init(scalable: 0, fixed: fixed)
  }
  
  static func scalable(_ scalable: CGFloat) -> Value {
    return Value.init(scalable: scalable, fixed: 0)
  }
  
  init(_ scalable: CGFloat) {
    self.scalable = scalable
    self.fixed = 0
  }
  
  init(scalable: CGFloat, fixed: CGFloat) {
    self.scalable = scalable
    self.fixed = fixed
  }
  
  public func scale(_ multiplier: CGFloat) -> CGFloat {
    return self.scalable * multiplier + self.fixed
  }
  
  public static prefix func -(item: Value) -> Value {
    return Value(scalable: -item.scalable, fixed: -item.fixed)
  }
  
  public static func *(lhs: Value, rhs: CGFloat) -> Value {
    return Value(scalable: lhs.scalable * rhs, fixed: lhs.fixed * rhs)
  }
  
  public static func +(lhs: Value, rhs: Value) -> Value {
    return Value(scalable: lhs.scalable + rhs.scalable, fixed: lhs.fixed + rhs.fixed)
  }
  
  public static func /(lhs: Value, rhs: CGFloat) -> Value {
    return Value(scalable: lhs.scalable / rhs, fixed: lhs.fixed / rhs)
  }
  
  public static func ==(lhs: Value, rhs: Value) -> Bool {
    return lhs.scalable == rhs.scalable && lhs.fixed == rhs.fixed
  }
}
