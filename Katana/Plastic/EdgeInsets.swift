//
//  EdgeInsets.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import CoreGraphics

/// `EdgeInsets` is the scalable counterpart of `UIEdgeInsets`
public struct EdgeInsets: Equatable {

  /// the top inset
  public let top: Value

  /// the left inset
  public let left: Value

  /// the bottom inset
  public let bottom: Value

  /// the right inset
  public let right: Value

  /// an instance of `EdgeInsets` with all the insets equal to zero
  public static let zero: EdgeInsets = .scalable(0, 0, 0, 0)

  /**
   Creates an instance of `EdgeInsets` where all the insets are not scalable
   
   - parameter top:    the value of the top inset
   - parameter left:   the value of the left inset
   - parameter bottom: the value of the bottom inset
   - parameter right:  the value of the right inset
   
   - returns: an instance of `EdgeInsets` where all the insets are not scalable
  */
  public static func fixed(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> EdgeInsets {
    return EdgeInsets(top: .fixed(top), left: .fixed(left), bottom: .fixed(bottom), right: .fixed(right))
  }

  /**
   Creates an instance of `EdgeInsets` where all the insets are scalable
   
   - parameter top:    the value of the top inset
   - parameter left:   the value of the left inset
   - parameter bottom: the value of the bottom inset
   - parameter right:  the value of the right inset
   
   - returns: an instance of `EdgeInsets` where all the insets are scalable
  */
  public static func scalable(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> EdgeInsets {
    return EdgeInsets(top: .scalable(top), left: .scalable(left), bottom: .scalable(bottom), right: .scalable(right))
  }

  /**
   Creates an instance of `EdgeInsets` with the given value
   
   - parameter top:    the value of the top inset
   - parameter left:   the value of the left inset
   - parameter bottom: the value of the bottom inset
   - parameter right:  the value of the right inset
   
   - returns: an instance of `EdgeInsets` with the given value
   */
  public init(top: Value, left: Value, bottom: Value, right: Value) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  /**
   Scales the insets using a multiplier
   
   - parameter multiplier: the multiplier to use to scale the insets
   - returns: an instance of `UIEdgeInsets` that is the result of the scaling process
  */
  public func scale(by multiplier: CGFloat) -> FloatEdgeInsets {
    return FloatEdgeInsets(
      top: self.top.scale(by: multiplier),
      left: self.left.scale(by: multiplier),
      bottom: self.bottom.scale(by: multiplier),
      right: self.right.scale(by: multiplier)
    )
  }

  /**
   Implements the multiplication for the `EdgeInsets` instances
   
   - parameter lhs: the `EdgeInsets` instance
   - parameter rhs: the the mutliplier to apply
   - returns: an instance of `EdgeInsets` where the values are multiplied by `rhs`
   
   - warning: this method is different from `scale(by:)` since it scales both
              scalable and fixed values, whereas `scale(by:)` scales only the scalable
              values
  */
  public static func * (lhs: EdgeInsets, rhs: CGFloat) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top * rhs,
      left: lhs.left * rhs,
      bottom: lhs.bottom * rhs,
      right: lhs.right * rhs
    )
  }

  /**
   Implements the addition for the `EdgeInsets` instances
   
   - parameter lhs: the first instance
   - parameter rhs: the second instance
   - returns: an instance of `EdgeInsets` where the insets are the sum of the insets of the two operators
   */
  public static func + (lhs: EdgeInsets, rhs: EdgeInsets) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top + rhs.top,
      left: lhs.left + rhs.left,
      bottom: lhs.bottom + rhs.bottom,
      right: lhs.right + rhs.right
    )
  }

  /**
   Implements the division for the `EdgeInsets` instances
   
   - parameter lhs: the first instance
   - parameter rhs: the value that will be used in the division
   - returns: an instance of `EdgeInsets` where the insets are divided by `rhs`
   */
  public static func / (lhs: EdgeInsets, rhs: CGFloat) -> EdgeInsets {
    return EdgeInsets(
      top: lhs.top / rhs,
      left: lhs.left / rhs,
      bottom: lhs.bottom / rhs,
      right: lhs.right / rhs
    )
  }

  /**
   Imlementation of the `Equatable` protocol.
   
   - parameter lhs: the first instance
   - parameter rhs: the second instance
   - returns: true if the two instances are equal, which means all the insets are equal
  */
  public static func == (lhs: EdgeInsets, rhs: EdgeInsets) -> Bool {
    return lhs.top == rhs.top &&
      lhs.left == rhs.left &&
      lhs.bottom == rhs.bottom &&
      lhs.right == rhs.right
  }
}
