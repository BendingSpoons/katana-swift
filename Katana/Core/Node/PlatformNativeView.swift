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

  /// The frame of the native view
  var frame: CGRect { get set }
  
  /// The alpha of the native view
  var alpha: CGFloat { get set }
  
  /// An unique tag value related to the native view
  var tagValue: Int { get set }

  /**
   Creates a new instance of the platform native view
   
   - returns: a valid instance of the platform native view
  */
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

  /**
   Adds the platform native view to a parent
   
   - parameter parent: the parent
  */
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

  /**
   Animates UI changes performed in a block with the animation specified by the AnimationType
   - parameter type: the type of the animation
   - parameter block: a block that contains the updates to the UI to animate
   - parameter completion: a block that is called when the animation completes
   */
  static func animate(type: AnimationType, _ block: @escaping ()->(), completion: (() -> ())?)
}
