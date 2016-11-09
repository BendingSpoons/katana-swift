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
  let childrenAnimation: AnyChildrenAnimations
  
  public static let none = AnimationContainer(nativeViewAnimation: .none, childrenAnimation: ChildrenAnimations<Any>())
  
  init(nativeViewAnimation: AnimationType, childrenAnimation: AnyChildrenAnimations) {
    self.nativeViewAnimation = nativeViewAnimation
    self.childrenAnimation = childrenAnimation
  }
  
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
