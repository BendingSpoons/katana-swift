//
//  EmptyHighlightableState.swift
//  Katana
//
//  Created by Mauro Bolis on 01/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct EmptyHighlightableState: NodeDescriptionState, Highlightable {
  public var highlighted: Bool
  
  public init() {
    self.highlighted = false
  }
  
  public init(highlighted: Bool) {
    self.highlighted = highlighted
  }
  
  public static func ==(lhs: EmptyHighlightableState, rhs: EmptyHighlightableState) -> Bool {
    return lhs.highlighted == rhs.highlighted
  }
}
