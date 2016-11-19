//
//  PlatformNativeView.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import CoreGraphics


/**
 This protocol abstracts how `Node` instances can be rendered. We have introduced this protocol
 to abstract the Katana world (nodes and descriptions) from the underlying implementation of how
 the UI is rendered.
 
 The most obvious implementation of this protocol is `UIView` for iOS or `NSView` for mac OS.
 It is possible to create custom containers that renders nodes on abstract structures (e.g., for testing)
 or on serializable structures to store the UI representation and use it later.
 
 */
public protocol PlatformNativeView : class {
  
  var frame: CGRect { get set } // native
  var alpha: CGFloat { get set }
  var tagValue: Int { get set }
  
  static func make() -> Self
  
  /**
   Removes all the children from the container
   
   - warning: this method should be invoked in the main queue
   */
  func removeAllChildren()
  
  /**
   Adds a child to the container
   
   - parameter child: a closure that returns the DrawableContainer to add to the container
   - returns: the container that holds the child
   
   - warning: this method should be invoked in the main queue
   */
  @discardableResult func addChild(_ child: () -> PlatformNativeView) -> PlatformNativeView
  
  func addToParent(parent: PlatformNativeView)
  
  /**
   Updates the description
   
   - parameter updateView: a closure that takes as input the PlatformNativeView represented by the container and
   updates it
   
   - warning: this method should be invoked in the main queue
   */
  func update(with updateView: (PlatformNativeView)->())
  
  /// Returns the children of the container
  func children () -> [PlatformNativeView]
  
  /**
   Moves to the front a child
   
   - parameter child: the child to move to the front
   */
  func bringChildToFront(_ child: PlatformNativeView)
  
  /**
   Removes a child
   
   - parameter child: the child to remove
   */
  func removeChild(_ child: PlatformNativeView)
}
