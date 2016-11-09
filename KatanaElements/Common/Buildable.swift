//
//  Builder.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public protocol Buildable {
  init()
  static func build(_ closure: (inout Self) -> Void) -> Self
}

public extension Buildable {
  static func build(_ closure: (inout Self) -> Void) -> Self {
    var sSelf = self.init()
    closure(&sSelf)
    return sSelf
  }
}
