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

  enum MergingPriority {
    case original, other
  }
  
  static func merge(
    array: [AnyNodeDescription],
    with other: [AnyNodeDescription],
    priority: MergingPriority) -> [AnyNodeDescription] {

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
        res.append(priority == .original ? itemArray : itemOther)
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
  
  static func updatedItems(
    from array: [AnyNodeDescription],
    notAvailableIn finalArray: [AnyNodeDescription],
    using childrenAnimation: ChildrenAnimationContainer) -> [AnyNodeDescription] {
    
    return array.map { item in
      let itemReplaceKey = item.replaceKey
      
      let index = finalArray.index { $0.replaceKey == itemReplaceKey }
      
      if index == nil {
        //TODO: update
        return item
      
      } else {
        return item
      }
    }
  }
}
