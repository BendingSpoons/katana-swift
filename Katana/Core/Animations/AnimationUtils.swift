//
//  AnimationUtils.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// Namespace for some animation utilities methods
struct AnimationUtils {
  private init () {}

  /// The intermediate steps of the 4 step animation
  enum AnimationStep {
    /// The first intermediate step
    case firstIntermediate
    
    /// The second intermediate step
    case secondIntermediate
  }

  /**
   Merges `descriptions` with `other` using a strategy that depends on the step.
   
   In general we have firstArray and secondArray. We merge secondArray in firstArray
   by trying to keep the positions (and the order) of firstArray the same.
   We also put the extra elements of secondArray in the result array by trying to keep
   the best possible position. We basically try to preserve the position of the extra elements
   between elements that are present also in the firstArray.
   
   When a value is present in both the first and second array, then the first array elements are used.
   
   When the step is the first, first array is `descriptions` and the second is `other`. In the second
   step we swap the roles.
   
   This method propagate this merging also to children of descriptions if possible.
   
   - parameter descriptions: the original descriptions
   - parameter other:        the other descriptions
   - parameter step:         the step of the process
   - returns: an array of descriptions with elements merged following the algorithm described above
   
  */
  static func merge(
    descriptions: [AnyNodeDescription],
    with other: [AnyNodeDescription],
    step: AnimationStep) -> [AnyNodeDescription] {
    
    let firstArray: [AnyNodeDescription]
    let secondArray: [AnyNodeDescription]
    
    switch step {
    case .firstIntermediate:
      firstArray = descriptions
      secondArray = other
      
    case .secondIntermediate:
      firstArray = other
      secondArray = descriptions
    }
    
    // lookup for first array
    var firstArrayLookup = [Int: Int]()
    for (index, item) in firstArray.enumerated() {
      firstArrayLookup[item.replaceKey] = index
    }
    
    // lookup for second array
    var secondArrayLookup = [Int: Int]()
    for (index, item) in secondArray.enumerated() {
      secondArrayLookup[item.replaceKey] = index
    }
    
    var result = firstArray
    var added = 0
    var firstArrayMaxPosition = -1
    
    for item in secondArray {
      let position = firstArrayLookup[item.replaceKey]
      
      if let position = position {
        // we already have the item
        firstArrayMaxPosition = max(firstArrayMaxPosition, position)
        continue
      }
      
      result.insert(item, at: added + firstArrayMaxPosition + 1)
      added = added + 1
    }

    
    // merge also children, if needed
    result = result.map { description in
      guard var propsWithChildren = description.anyProps as? Childrenable else {
        return description
      }
      
      let secondItemChildren = secondArrayLookup[description.replaceKey]
        .flatMap({ secondArray[$0] })
        .flatMap({ $0 as? AnyNodeDescriptionWithChildren })
        .flatMap({ $0.children })
      
      
      propsWithChildren.children = merge(
        descriptions: propsWithChildren.children,
        with: secondItemChildren ?? [],
        step: step
      )
      
      return type(of: description).init(anyProps: propsWithChildren as! AnyNodeDescriptionProps)
    }
    
    return result
  }
  
  /**
   Updates the descriptions using an instance of `ChildrenAnimations`.
   
   The idea is that, based on the targetChildren, we understand which descriptions are not present.
   We then apply some transformations.
   
   The transformations are defined using the step. When the step is the first, we use enter transformation.
   In the second step, we use the leave transformation
   
   This method propagate this merging also to children of descriptions if possible.
   
   - parameter descriptions:        the original descriptions
   - parameter childrenAnimation:   the animations to use
   - parameter targetChildren:      the target children used to define when apply a transformation
   - parameter step:         the step of the process
   - returns: an array of updated descriptions
  */
  static func updatedDescriptions(
    for descriptions: [AnyNodeDescription],
    using childrenAnimation: AnyChildrenAnimations,
    targetChildren: [AnyNodeDescription],
    step: AnimationStep) -> [AnyNodeDescription] {
    
    return descriptions.map { (item: AnyNodeDescription) -> AnyNodeDescription in
      let itemReplaceKey = item.replaceKey
      let index = targetChildren.index { $0.replaceKey == itemReplaceKey }
      var item = item
      
      if index == nil {
        // the item is missing in the comparison, update it
        item = self.updatedDescription(for: item, using: childrenAnimation, step: step)
      }
      
      if var propsWithChildren = item.anyProps as? Childrenable {
        // the item has children, let's manage also the children
        let children = propsWithChildren.children
        let target = (targetChildren[index!] as? AnyNodeDescriptionWithChildren).flatMap({ $0.children })
        
        propsWithChildren.children = updatedDescriptions(
          for: children,
          using: childrenAnimation,
          targetChildren: target ?? [],
          step: step
        )
        
        return type(of: item).init(anyProps: propsWithChildren as! AnyNodeDescriptionProps)
      }
      
      // nothing to do
      return item
    }
  }
  
  /**
   Updates the description using an instance of `ChildrenAnimations`.
   
   - parameter description:         the original description
   - parameter childrenAnimation:   the animations to use
   - parameter step:         the step of the process
   - returns: the updated description
  */
  private static func updatedDescription(
    for description: AnyNodeDescription,
    using childrenAnimation: AnyChildrenAnimations,
    step: AnimationStep) -> AnyNodeDescription {

    let animation = childrenAnimation[description]
    let transformers = step == .firstIntermediate ? animation.entryTransformers : animation.leaveTransformers
    
    let newProps = transformers.reduce(description.anyProps, { (props, transformer) -> AnyNodeDescriptionProps in
      return transformer(props)
    })
    
    return type(of: description).init(anyProps: newProps)
  }
}
