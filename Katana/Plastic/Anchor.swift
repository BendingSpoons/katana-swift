//
//  Anchor.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import CoreGraphics


public struct Anchor: Equatable {
  public enum Kind {
    case left, right, centerX, top, bottom, centerY
  }
  
  let kind: Kind
  let view: PlasticView
  
  init(kind: Kind, view: PlasticView) {
    self.kind = kind
    self.view = view
  }
  
  var coordinate: CGFloat {
    let absoluteOrigin = self.view.absoluteOrigin
    let size = self.view.frame
    
    switch self.kind {
    case .left:
      return absoluteOrigin.x
    
    case .right:
      return absoluteOrigin.x + size.width
    
    case .centerX:
      return absoluteOrigin.x + size.width / 2.0
      
    case .top:
      return absoluteOrigin.y
      
    case .bottom:
      return absoluteOrigin.y + size.height
      
    case .centerY:
      return absoluteOrigin.y + size.height / 2.0
      
    }
  }
  
  public static func == (lhs: Anchor, rhs: Anchor) -> Bool {
    return lhs.kind == rhs.kind && lhs.view === rhs.view
  }
}
