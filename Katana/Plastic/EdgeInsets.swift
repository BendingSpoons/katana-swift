//
//  EdgeInsets.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

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
  public static let zero = EdgeInsets(0, 0, 0, 0)
  
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
   Creates an instance of `EdgeInsets` where all the insets are scalable
   
   - parameter top:    the value of the top inset
   - parameter left:   the value of the left inset
   - parameter bottom: the value of the bottom inset
   - parameter right:  the value of the right inset
   
   - returns: an instance of `EdgeInsets` where all the insets are not scalable
   
   - warning: Always prefer the static methdo `scalable(_:_:_:_:)` instead of this constructor
  */
  public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
    self.top = Value(top)
    self.left = Value(left)
    self.bottom = Value(bottom)
    self.right = Value(right)
  }
  
  
  /**
   Creates an instance of `EdgeInsets` with the given values

   - parameter scalableTop:    the scalable value of the top inset
   - parameter fixedTop:       the fixed value of the top inset
   - parameter scalableLeft:   the scalable value of the left inset
   - parameter fixedLeft:      the fixed value of the left inset
   - parameter scalableBottom: the scalable value of the bottom inset
   - parameter fixedBottom:    the fixed value of the bottom inset
   - parameter scalableRight:  the scalable value of the right inset
   - parameter fixedRight:     the fixed value of the right inset
   
   - returns: an instance of `EdgeInsets` with the given values
  */
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
  public func scale(by multiplier: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(
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
