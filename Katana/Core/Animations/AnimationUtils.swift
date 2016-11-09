//
//  AnimationUtils.swift
//  Katana
//
//  Created by Mauro Bolis on 07/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

struct AnimationUtils {
  private init () {}

  enum AnimationStep {
    case firstIntermediate, secondIntermediate
  }
  
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
      
      return type(of: description).init(anyProps: propsWithChildren as! AnyNodeProps)
    }
    
    return result
  }
  
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
        
        return type(of: item).init(anyProps: propsWithChildren as! AnyNodeProps)
      }
      
      // nothing to do
      return item
    }
  }
  
  private static func updatedDescription(
    for description: AnyNodeDescription,
    using childrenAnimation: AnyChildrenAnimations,
    step: AnimationStep) -> AnyNodeDescription {

    let animation = childrenAnimation[description]
    let transformers = step == .firstIntermediate ? animation.entryTransformers : animation.leaveTransformers
    
    let newProps = transformers.reduce(description.anyProps, { (props, transformer) -> AnyNodeProps in
      return transformer(props)
    })
    
    return type(of: description).init(anyProps: newProps)
  }
}
