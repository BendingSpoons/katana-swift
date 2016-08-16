//
//  Value.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct Value: Equatable {
  let scalable: Float
  let fixed: Float
  
  var unscaledValue: Float {
    return scalable + fixed
  }
  
  static let zero = Value(0)
  
  init(_ scalable: Float) {
    self.scalable = scalable
    self.fixed = 0
  }
  
  init(scalable: Float, fixed: Float) {
    self.scalable = scalable
    self.fixed = fixed
  }
  
  public func scale(_ multiplier: Float) -> Float {
    return self.scalable * multiplier + self.fixed
  }
  
  public static prefix func -(item: Value) -> Value {
    return Value(scalable: -item.scalable, fixed: -item.fixed)
  }
  
  public static func *(lhs: Value, rhs: Float) -> Value {
    return Value(scalable: lhs.scalable * rhs, fixed: lhs.fixed * rhs)
  }
  
  public static func +(lhs: Value, rhs: Value) -> Value {
    return Value(scalable: lhs.scalable + rhs.scalable, fixed: lhs.fixed + rhs.fixed)
  }
  
  public static func /(lhs: Value, rhs: Float) -> Value {
    return Value(scalable: lhs.scalable / rhs, fixed: lhs.fixed / rhs)
  }
  
  public static func ==(lhs: Value, rhs: Value) -> Bool {
    return lhs.scalable == rhs.scalable && lhs.fixed == rhs.fixed
  }
}
