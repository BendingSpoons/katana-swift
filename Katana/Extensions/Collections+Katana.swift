//
//  Collections+Katana.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

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
