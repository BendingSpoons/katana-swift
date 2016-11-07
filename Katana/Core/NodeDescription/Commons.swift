//
//  CommonProps.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

/// Protocol for description's properties that allow the description to have a frame
public protocol Frameable {
  /// The frame
  var frame: CGRect {get set}
}

/**
  Protocol for description's properties that allow the description to have a key.
  The key is used for many purposes. It is used for instance to calculate a more precise `replaceKey`
  and from Plastic to implement the layout system
 
  - seeAlso: `NodeDescription`, `replaceKey`
*/
public protocol Keyable {
  
  /// The key
  var key: String? { get set }
  
  /**
    Helper method to translate any Swift value to a key, which is a String
    
   - parameter key: the key
  */
  mutating func setKey<K>(_ key: K)
}

public extension Keyable {
  /// The default implementation uses the Swift string interpolation to create the key
  public mutating func setKey<Key>(_ key: Key) {
    self.key = "\(key)"
  }
}

/// The default props for a `NodeDescription`. Besides `frame` and `key`, this struct doesn't have any other property
public struct EmptyProps: NodeDescriptionProps, Keyable {
  
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
      lhs.key == rhs.key
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
