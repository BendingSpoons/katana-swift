//
//  UInt32+Node.swift
//  Katana
//
//  Created by Mauro Bolis on 10/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/// Int utilities for `Node`
extension Int {
  /// A random `Int` value
  static var random: Int {
    return Int(arc4random_uniform(UInt32.max))
  }
}
