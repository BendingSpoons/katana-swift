//
//  ChildrenAnimations.swift
//  Katana
//
//  Created by Mauro Bolis on 07/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct ChildrenAnimations<Key> {
  var shouldAnimate = false
  var animations = [String: Animation]()
  
  public subscript(key: Key) -> Animation {
    get {
      return self.animations["\(key)"] ?? .none
    }
    
    set(newValue) {
      if case .none = newValue.type {
        return
      }
      
      self.shouldAnimate = true
      self.animations["\(key)"] = newValue
    }
  }
}

protocol AnyChildrenAnimations {
  var shouldAnimate: Bool { get }
  subscript(description: AnyNodeDescription) -> Animation { get }
}

extension ChildrenAnimations: AnyChildrenAnimations {
  subscript(key: String) -> Animation {
    return self.animations[key] ?? .none
  }
  
  subscript(description: AnyNodeDescription) -> Animation {
    if let props = description.anyProps as? Keyable, let key = props.key {
      return self[key]
    }
    
    return .none
  }
}
