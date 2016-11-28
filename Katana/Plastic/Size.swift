//
//  Size.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import CoreGraphics

/// `Size` is the scalable counterpart of `CGSize`
public struct Size: Equatable {
  
  /// The width value
  public let width: Value
  
  /// The height value
  public let height: Value
  
  /// an instance of `Size` where both the width and the height are zero
  public static let zero: Size = .scalable(0, 0)
  
  /**
   Creates an instance of `Size` where both widht and height are fixed
   
   - parameter width:    the value of the width
   - parameter height:   the value of the height
   
   - returns: an instance of `Size` where both width and height are fixed
  */
  public static func fixed(_ width: CGFloat, _ height: CGFloat) -> Size {
    return Size(width: .fixed(width), height: .fixed(height))
  }

  /**
   Creates an instance of `Size` where both widht and height are scalable
   
   - parameter width:    the value of the width
   - parameter height:   the value of the height
   
   - returns: an instance of `Size` where both width and height are scalable
  */
  public static func scalable(_ width: CGFloat, _ height: CGFloat) -> Size {
    return Size(width: .scalable(width), height: .scalable(height))
  }
  
  /**
   Creates an instance of `Size` with the given value
   
   - parameter width:    the width to use
   - parameter height:   the height to use
   
   - returns: an instance of `Size` with the given value
  */
  public init(width: Value, height: Value) {
    self.width = width
    self.height = height
  }
  
  /**
   Scales the size using a multiplier
   
   - parameter multiplier: the multiplier to use to scale the size
   - returns: an instance of `CGSize` that is the result of the scaling process
  */
  public func scale(by multiplier: CGFloat) -> CGSize {
    return CGSize(
      width: self.width.scale(by: multiplier),
      height: self.height.scale(by: multiplier)
    )
  }
  
  /**
   Implements the multiplication for the `Size` instances
   
   - parameter lhs: the `Size` instance
   - parameter rhs: the the mutliplier to apply
   - returns: an instance of `Size` where the values are multiplied by `rhs`
   
   - warning: this method is different from `scale(by:)` since it scales both
              scalable and fixed values, whereas `scale(by:)` scales only the scalable
              values
  */
  public static func * (lhs: Size, rhs: CGFloat) -> Size {
    return Size(width: lhs.width * rhs, height: lhs.height * rhs)
  }
  
  /**
   Implements the addition for the `Size` instances
   
   - parameter lhs: the first instance
   - parameter rhs: the second instance
   - returns: an instance of `Size` where the width and the height are the sum of the insets of      
              the two operators
  */
  public static func + (lhs: Size, rhs: Size) -> Size {
    return Size(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }
  
  /**
   Implements the division for the `Size` instances
   
   - parameter lhs: the first instance
   - parameter rhs: the value that will be used in the division
   - returns: an instance of `Size` where the insets are divided by `rhs`
  */
  public static func / (lhs: Size, rhs: CGFloat) -> Size {
    return Size(width: lhs.width / rhs, height: lhs.height / rhs)
  }
  
  /**
   Imlementation of the `Equatable` protocol.
   
   - parameter lhs: the first instance
   - parameter rhs: the second instance
   - returns: true if the two instances are equal, which means that both width and height are equal
  */
  public static func == (lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
  }
}
