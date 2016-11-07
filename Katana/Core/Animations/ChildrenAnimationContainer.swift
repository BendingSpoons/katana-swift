//
//  AnimationContainer.swift
//  Katana
//
//  Created by Mauro Bolis on 07/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct ChildrenAnimationContainer {
  var shouldAnimate = false
  
  public subscript(key: AnyNodeDescription) -> Animation {
    // TODO: implement (use also shouldAnimate)
    return .none
  }
}
