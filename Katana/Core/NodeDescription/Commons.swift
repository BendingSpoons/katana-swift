//
//  Commons.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit

/// The default props for a `NodeDescription`. Besides `frame` and `key`, this struct doesn't have any other property
public struct EmptyProps: NodeDescriptionProps {
  /// The alpha of the description
  public var alpha: CGFloat = 1.0
  
  /// The key of the description
  public var key: String?
  
  /// The frame of the description
  public var frame: CGRect = CGRect.zero
  
  /**
   Implementation of the `Equatable` protocol
   
   - parameter lhs: the first props
   - parameter rhs: the second props
   - returns: true if frame and key are the same, false otherwise
  */
  public static func == (lhs: EmptyProps, rhs: EmptyProps) -> Bool {
    return
      lhs.frame == rhs.frame &&
      lhs.key == rhs.key &&
      lhs.alpha == rhs.alpha
  }

  
  /**
    Default initializer of the struct
    - returns: a valid instance of EmptyProps
  */
  public init() {}
}

/// The default state for a `NodeDescription`. This struct is basically empty
public struct EmptyState: NodeDescriptionState {
  /**
   Implementation of the `Equatable` protocol
   
   - parameter lhs: the first state
   - parameter rhs: the second state
   - returns: true
   */
  public static func == (lhs: EmptyState, rhs: EmptyState) -> Bool {
    return true
  }
  
  /**
   Default initializer of the struct
   - returns: a valid instance of EmptyState
  */
  public init() {}
}
