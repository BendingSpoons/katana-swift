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

    var arrayIndexes = [Int:Int]()
    for (index, item) in array.enumerated() {
      arrayIndexes[item.replaceKey] = index
    }
    
    var otherIndexes = [Int:Int]()
    for (index, item) in other.enumerated() {
      otherIndexes[item.replaceKey] = index
    }
    
    var indexArray = 0
    var indexOther = 0
    var res = [AnyNodeDescription]()
    
    while indexArray < array.count && indexOther < other.count {
      let itemArray = array[indexArray]
      let itemOther = other[indexOther]
      
      if itemArray.replaceKey == itemOther.replaceKey {
        res.append(step == .firstIntermediate ? itemArray : itemOther)
        indexArray = indexArray + 1
        indexOther = indexOther + 1
        
      } else if arrayIndexes[itemArray.replaceKey]! < otherIndexes[itemOther.replaceKey]! {
        res.append(itemArray)
        indexArray = indexArray + 1
        
      } else {
        res.append(itemOther)
        indexOther = indexOther + 1
      }
    }
    
    while indexArray < array.count {
      res.append(array[indexArray])
      indexArray = indexArray + 1
    }
    
    while indexOther < other.count {
      res.append(other[indexOther])
      indexOther = indexOther + 1
    }
    
    return res
  }
  
  static func updatedChildren(
    in array: [AnyNodeDescription],
    initialChildren: [AnyNodeDescription],
    finalChildren: [AnyNodeDescription],
    using childrenAnimation: AnyChildrenAnimationContainer,
    step: AnimationStep) -> [AnyNodeDescription] {
    
    let comparisonArray = step == .firstIntermediate ? initialChildren : finalChildren
    
    return array.map { item in
      let itemReplaceKey = item.replaceKey
      let index = comparisonArray.index { $0.replaceKey == itemReplaceKey }
      
      guard index == nil else {
        // we have the item in the reference children array, we don't to calculate
        // additional properties
        return item
      }
      
      let animation = childrenAnimation[item]
      let transformers = step == .firstIntermediate ? animation.entryTransformers : animation.leaveTransformers
      
      return self.update(description: item, with: transformers)
    }
  }
  
  private static func update(
    description: AnyNodeDescription,
    with transformers: [AnimationPropsTransformer]) -> AnyNodeDescription {

    let newProps = transformers.reduce(description.anyProps, { (props, transformer) -> AnyNodeProps in
      return transformer(props)
    })
    
//    if var newProps = newProps as? (Childrenable & AnyNodeProps) {
//      // if it has children, we should propagate changes
//      newProps.children = newProps.children.map { self.update(description: $0, with: transformers) }
//      return type(of: description).init(anyProps: newProps)
//    
//    } else {
//      // just return
      return type(of: description).init(anyProps: newProps)
//    }
  }
}
