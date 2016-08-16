//
//  PlasticValue.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct PlasticValue: Equatable {
  let scalable: Float
  let fixed: Float
  
  var unscaledValue: Float {
    return scalable + fixed
  }
  
  static let zero = PlasticValue(0)
  
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
  
  public static prefix func -(item: PlasticValue) -> PlasticValue {
    return PlasticValue(scalable: -item.scalable, fixed: -item.fixed)
  }
  
  public static func *(lhs: PlasticValue, rhs: Float) -> PlasticValue {
    return PlasticValue(scalable: lhs.scalable * rhs, fixed: lhs.fixed * rhs)
  }
  
  public static func +(lhs: PlasticValue, rhs: PlasticValue) -> PlasticValue {
    return PlasticValue(scalable: lhs.scalable + rhs.scalable, fixed: lhs.fixed + rhs.fixed)
  }
  
  public static func /(lhs: PlasticValue, rhs: Float) -> PlasticValue {
    return PlasticValue(scalable: lhs.scalable / rhs, fixed: lhs.fixed / rhs)
  }
  
  public static func ==(lhs: PlasticValue, rhs: PlasticValue) -> Bool {
    return lhs.scalable == rhs.scalable && lhs.fixed == rhs.fixed
  }
}
