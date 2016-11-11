//
//  Animation.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 The animation for a child of a `NodeDescription`.
 
 The idea is that, for elements that are either created or destroyed during an animation,
 we will compute initial or final state and then animate to/from there.
 
 When an element is created during an animated update, we take the final state (that is, the state
 you have returned in the `childrenDescription` method) and we apply the transformers
 you have specified in `entryTransformers`.
 The resulting props are used to render an intermediated state that will be animated to the final state.
 
 When an element is destroyed during an animated update, something similar happens. The only difference is that
 we take the initial state (that is, the state of the last render when the element was present) and we apply the
 transformers you have specified in `leaveTransformers`
 */
public struct Animation {
  /// The animation type to perform for the child
  let type: AnimationType
  
  /// The entry phase transformers
  let entryTransformers: [AnimationPropsTransformer]
  
  /// The leave entry phase transformers
  let leaveTransformers: [AnimationPropsTransformer]
  
  /// An empty animation
  static let none = Animation(type: .none)
  
  /**
   Creates an animation with the given values
   
   - parameter type: the type of animation to apply to the child
   - parameter entryTransformers: the transformers to use in the entry phase
   - parameter leaveTransformers: the transformers to use in the leave phase
   - returns: an animation with the given parameters
   */
  public init(type: AnimationType,
              entryTransformers: [AnimationPropsTransformer],
              leaveTransformers: [AnimationPropsTransformer]) {
    
    self.type = type
    self.entryTransformers = entryTransformers
    self.leaveTransformers = leaveTransformers
  }
  
  /**
   Creates an animation with the given values
   
   - parameter type: the type of animation to apply to the child
   - returns: an animation with the given animation type and no transformers
   */
  public init(type: AnimationType) {
    self.type = type
    self.entryTransformers = []
    self.leaveTransformers = []
  }
}
