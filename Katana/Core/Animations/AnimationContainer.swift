//
//  AnimationContainer.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 A container for animations.
 It contains both the animation to perform when the native view is updated and also
 the animations to use for children
*/
public struct AnimationContainer {
  /// The animation to use for the native view
  let nativeViewAnimation: AnimationType

  /// The animations for the children
  let childrenAnimation: AnyChildrenAnimations

  /// An empty animation
  public static let none = AnimationContainer(nativeViewAnimation: .none, childrenAnimation: ChildrenAnimations<Any>())

  /**
   Creates a container with the given values
   
   - parameter nativeViewAnimation: the animation to perform when the native view is updated
   - parameter childrenAnimation:   the animation of the children
  */
  init(nativeViewAnimation: AnimationType, childrenAnimation: AnyChildrenAnimations) {
    self.nativeViewAnimation = nativeViewAnimation
    self.childrenAnimation = childrenAnimation
  }

  /**
   Creates an instance of `AnimationContainer` for a given child
   
   - parameter child: the child
   - returns: an `AnimationContainer` that can be used to animate the child
  */
  func animation(for child: AnyNodeDescription) -> AnimationContainer {
    // If the child implements the NodeDescriptionWithChildren protocol, then we need
    // to forward the animations down in the hierarchy
    let childChildrenAnimation = child is AnyNodeDescriptionWithChildren
      ? self.childrenAnimation
      : ChildrenAnimations<Any>()

    return AnimationContainer(
      nativeViewAnimation: self.childrenAnimation[child].type,
      childrenAnimation: childChildrenAnimation
    )
  }
}
