//
//  Builder.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

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
