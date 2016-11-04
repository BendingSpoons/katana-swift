//
//  Array+Katana.swift
//  Katana
//
//  Created by Luca Querella on 12/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element: Comparable {

  /// Returns true if the collection is sorted
  var isSorted: Bool {
    var iterator = makeIterator()
    if var previous = iterator.next() {
      while let element = iterator.next() {
        if previous > element {
          return false
        }
        previous = element
      }
    }
    return true
  }
}
