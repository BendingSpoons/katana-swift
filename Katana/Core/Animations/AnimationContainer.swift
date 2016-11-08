//
//  AnimationContainer.swift
//  Katana
//
//  Created by Mauro Bolis on 07/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct AnimationContainer {
  let nativeViewAnimation: AnimationType
  let childrenAnimation: AnyChildrenAnimationContainer
  
  public static let none = AnimationContainer(nativeViewAnimation: .none, childrenAnimation: ChildrenAnimationContainer<Any>())
  
  init(nativeViewAnimation: AnimationType, childrenAnimation: AnyChildrenAnimationContainer) {
    self.nativeViewAnimation = nativeViewAnimation
    self.childrenAnimation = childrenAnimation
  }
  
  func animation(for child: AnyNodeDescription) -> AnimationContainer {
    // If the child implements the NodeDescriptionWithChildren protocol, then we need
    // to forward the animations down in the hierarchy
    //
    // Theoretically we should only pass animations for the children of the child
    // we don't do it to avoid useless operations
    let childChildrenAnimation = child is AnyNodeDescriptionWithChildren
      ? self.childrenAnimation
      : ChildrenAnimationContainer<Any>()
    
    return AnimationContainer(
      nativeViewAnimation: self.childrenAnimation[child].type,
      childrenAnimation: childChildrenAnimation
    )
  }
}
