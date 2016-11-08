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
    array: [AnyNodeDescription],
    with other: [AnyNodeDescription],
    step: AnimationStep) -> [AnyNodeDescription] {
    
    let firstArray: [AnyNodeDescription]
    let secondArray: [AnyNodeDescription]
    
    switch step {
    case .firstIntermediate:
      firstArray = array
      secondArray = other
      
    case .secondIntermediate:
      firstArray = other
      secondArray = array
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
        .flatMap({ $0 as! AnyNodeDescriptionWithChildren })
        .flatMap({ $0.children })
      
      
      propsWithChildren.children = merge(
        array: propsWithChildren.children,
        with: secondItemChildren ?? [],
        step: step
      )
      
      return type(of: description).init(anyProps: propsWithChildren as! AnyNodeProps)
    }
    
    return result
  }
  
  static func updatedChildren(
    in array: [AnyNodeDescription],
    using childrenAnimation: AnyChildrenAnimationContainer,
    targetChildren: [AnyNodeDescription],
    step: AnimationStep) -> [AnyNodeDescription] {
    
    var newChildren = array.map { (item: AnyNodeDescription) -> AnyNodeDescription in
      let itemReplaceKey = item.replaceKey
      let index = targetChildren.index { $0.replaceKey == itemReplaceKey }
      
      if index == nil {
        // the item is missing in the comparison, update it
        return self.update(description: item, using: childrenAnimation, step: step)
      }
      
      if var propsWithChildren = item.anyProps as? Childrenable {
        // the item is not missing, but it may have children. Let's manage them
        let children = propsWithChildren.children
        let target = (targetChildren[index!] as? AnyNodeDescriptionWithChildren).flatMap({ $0.children })
        
        propsWithChildren.children = updatedChildren(
          in: children,
          using: childrenAnimation,
          targetChildren: target ?? [],
          step: step
        )
        
        return type(of: item).init(anyProps: propsWithChildren as! AnyNodeProps)
      }
      
      // nothing to do
      return item
    }
    
    return newChildren
  }
  
  private static func update(
    description: AnyNodeDescription,
    using childrenAnimation: AnyChildrenAnimationContainer,
    step: AnimationStep) -> AnyNodeDescription {

    let animation = childrenAnimation[description]
    let transformers = step == .firstIntermediate ? animation.entryTransformers : animation.leaveTransformers
    
    let newProps = transformers.reduce(description.anyProps, { (props, transformer) -> AnyNodeProps in
      return transformer(props)
    })
    
    if var propsWithChildren = newProps as? Childrenable {
      // Theoretically we should cast in this way `newProps as? Childrenable & AnyNodeDescription`.
      // In this way we avoid the force cast when we instanciate the description.
      // This currently leads to a runtime crash, we should further investigate it
      
      // if it has children, we should propagate changes
      propsWithChildren.children = propsWithChildren.children.map {
        self.update(description: $0, using: childrenAnimation, step: step)
      }

      return type(of: description).init(anyProps: propsWithChildren as! AnyNodeProps)
    
    } else {
      // just return
      return type(of: description).init(anyProps: newProps)
    }
  }
}
