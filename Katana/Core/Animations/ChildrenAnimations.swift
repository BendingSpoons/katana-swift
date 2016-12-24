//
//  ChildrenAnimations.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 This struct is used as container to define the animations for the children
*/
public struct ChildrenAnimations<Key> {
  /// It indicates whether we should perform a 4 step animation or not
  var shouldAnimate = false

  /// The animations of the children
  var animations = [String: Animation]()

  /// A default that is used for all the children without a specific animation
  public var allChildren: Animation = .none {
    didSet {
      if case .none = self.allChildren.type {
        return
      }

      self.shouldAnimate = true
    }
  }

  /**
   Gets the `Animation` value relative to a specific key
   
   - parameter key: the key of the children to retrieve
   - returns: the `Animation` value related to the key
   
   If the key has not been defined, the `allChildren` value is returned
  */
  public subscript(key: Key) -> Animation {
    get {
      return self["\(key)"]
    }

    set(newValue) {
      if case .none = newValue.type {
        return
      }

      self.shouldAnimate = true
      self.animations["\(key)"] = newValue
    }
  }

  /**
   - note: This subscript should be used only to set values.
   
   It is an helper to specify the same animation for multiple keys
  */
  public subscript(key: [Key]) -> Animation {
    get {
      fatalError("This subscript should not be used as a getter")
    }

    set(newValue) {
      for value in key {
        self[value] = newValue
      }
    }
  }

  /**
   Gets the `Animation` value relative to a specific key
   
   - parameter key: the key of the children to retrieve
   - returns: the `Animation` value related to the key
   
   If the key has not been defined, the `allChildren` value is returned
  */
  subscript(key: String) -> Animation {
    return self.animations[key] ?? self.allChildren
  }
}

/// Type Erasure for ChildrenAnimations
protocol AnyChildrenAnimations {
  /// It indicates whether we should perform a 4 step animation or not
  var shouldAnimate: Bool { get }

  /**
   Gets the `Animation` value relative to a description
   
   - parameter description: the description
   - returns: the `Animation` value related to the description
   
   If the children doesn't have a specific value, the `allChildren` value is returned
   */
  subscript(description: AnyNodeDescription) -> Animation { get }
}

/// Implementation of AnyChildrenAnimations
extension ChildrenAnimations: AnyChildrenAnimations {
  /**
   Implementation of the AnyChildrenAnimations protocol.
   
   - seeAlso: `AnyChildrenAnimations`
  */
  subscript(description: AnyNodeDescription) -> Animation {
    if let key = description.anyProps.key {
      return self[key]
    }

    return self.allChildren
  }
}
