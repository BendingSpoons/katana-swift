//
//  Value.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit

/**
 `Value` is the scalable counterpart of `CGFloat`.
 It is composed by two parts: scalable and fixed. When
 scaling the value with a multiplier, the final value will be
 `scalable * multiplier + fixed`.
*/
public struct Value: Equatable {
  
  /// The scalable part of the instance
  public let scalable: CGFloat
  
  /// The fixed part of the instance
  public let fixed: CGFloat
  
  /// Returns the unscaled value of the instance
  public var unscaledValue: CGFloat {
    return scalable + fixed
  }
  
  /// an instance of `Value` with a value equals to 0
  public static let zero = Value(0)
  
  /**
   Creates a fixed instance of `Value`
   
   - parameter fixed:  the value of the instance
   - returns: an instance of `Value` with the given fixed value
  */
  public static func fixed(_ fixed: CGFloat) -> Value {
    return Value.init(scalable: 0, fixed: fixed)
  }

  /**
   Creates a scalable instance of `Value`
   
   - parameter scalable:  the value of the instance
   - returns: an instance of `Value` with the given scalable value
  */
  public static func scalable(_ scalable: CGFloat) -> Value {
    return Value.init(scalable: scalable, fixed: 0)
  }
  
  /**
   Creates a scalable instance of `Value`
   
   - parameter scalable:  the value of the instance
   - returns: an instance of `Value` with the given scalable value
   
   - warning: Always prefer the static method `scalable(_:)` instead of this constructor
  */
  public init(_ scalable: CGFloat) {
    self.scalable = scalable
    self.fixed = 0
  }
  
  /**
   Creates an instance of `Value` with the given values
   
   - parameter scalable:    the scalable part of the instance
   - parameter fixed:       the fixed part of the instance
   
   - returns: an instance of `Value` with the given values
  */
  public init(scalable: CGFloat, fixed: CGFloat) {
    self.scalable = scalable
    self.fixed = fixed
  }
  
  /**
   Scales the value using a multiplier
   
   - parameter multiplier: the multiplier to use to scale the value
   - returns: an instance of `Value` that is the result of the scaling process
  */
  public func scale(by multiplier: CGFloat) -> CGFloat {
    return self.scalable * multiplier + self.fixed
  }
  
  /**
   Returns a new `Value` instance with the sign changed
   
   - parameter item: the value to change
   - returns: an instance of `Value` where both the scalable and the fixed parts have
              the sign changed
  */
  public static prefix func - (item: Value) -> Value {
    return Value(scalable: -item.scalable, fixed: -item.fixed)
  }
  
  /**
   Implements the multiplication for the `Value` instances
   
   - parameter lhs: the `Valuee` instance
   - parameter rhs: the the mutliplier to apply
   - returns: an instance of `Value` where the values are multiplied by `rhs`
   
   - warning: this method is different from `scale(by:)` since it scales both
   scalable and fixed parts, whereas `scale(by:)` scales only the scalable
   part
  */
  public static func * (lhs: Value, rhs: CGFloat) -> Value {
    return Value(scalable: lhs.scalable * rhs, fixed: lhs.fixed * rhs)
  }
  
  /**
   Implements the addition for the `Value` instances
   
   - parameter lhs: the first instance
   - parameter rhs: the second instance
   - returns: an instance of `Value` where the fixed and scalable parts are the sum of the parts of the two operators
  */
  public static func + (lhs: Value, rhs: Value) -> Value {
    return Value(scalable: lhs.scalable + rhs.scalable, fixed: lhs.fixed + rhs.fixed)
  }
  
  /**
   Implements the division for the `Value` instances
   
   - parameter lhs: the first instance
   - parameter rhs: the value that will be used in the division
   - returns: an instance of `Value` where the insets are divided by `rhs`
  */
  public static func / (lhs: Value, rhs: CGFloat) -> Value {
    return Value(scalable: lhs.scalable / rhs, fixed: lhs.fixed / rhs)
  }
  
  /**
   Imlementation of the `Equatable` protocol.
   
   - parameter lhs: the first instance
   - parameter rhs: the second instance
   - returns: true if the two instances are equal, which means both the scalable and the fixed parts are equal
  */
  public static func == (lhs: Value, rhs: Value) -> Bool {
    return lhs.scalable == rhs.scalable && lhs.fixed == rhs.fixed
  }
}
