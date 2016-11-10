//
//  Highlightable.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana

public protocol Highlightable {
  var highlighted: Bool { get set }
}

public struct EmptyHighlightableState: NodeDescriptionState, Highlightable {
  public var highlighted: Bool
  
  public init() {
    self.highlighted = false
  }
  
  public init(highlighted: Bool) {
    self.highlighted = highlighted
  }
  
  public static func == (lhs: EmptyHighlightableState, rhs: EmptyHighlightableState) -> Bool {
    return lhs.highlighted == rhs.highlighted
  }
}
