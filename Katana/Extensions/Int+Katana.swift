//
//  UInt32+Node.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.
//

import Foundation

/// Int utilities for `Node`
extension Int {
  /// A random `Int` value
  static var random: Int {
    let maxRandom = MemoryLayout<Int>.size == MemoryLayout<Int32>.size ? UInt32(Int32.max) : UInt32.max
    return Int(arc4random_uniform(maxRandom))
  }
}
