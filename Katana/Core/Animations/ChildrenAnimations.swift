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
  
  var allChildren: Animation = .none {
    didSet {
      if case .none = self.allChildren.type {
        return
      }

      self.shouldAnimate = true
    }
  }
  
  public subscript(key: Key) -> Animation {
    get {
      return self["\(key)"]
    }
    
    set(newValue) {
      if case .none = newValue.type {
        return
      }
      
      self.shouldAnimate = true
      self.animations["\(key)"] = newValue
    }
  }
  
  public subscript(key: [Key]) -> Animation {
    get {
      fatalError("This subscript should not be used as a getter")
    }
    
    set(newValue) {
      for value in key {
        self[value] = newValue
      }
    }
  }
  
  private mutating func update(key: Key, newValue: Animation) {
    if case .none = newValue.type {
      return
    }
    
    self.shouldAnimate = true
    self.animations["\(key)"] = newValue
  }
}

protocol AnyChildrenAnimations {
  var shouldAnimate: Bool { get }
  subscript(description: AnyNodeDescription) -> Animation { get }
}

extension ChildrenAnimations: AnyChildrenAnimations {
  subscript(key: String) -> Animation {
    return self.animations[key] ?? self.allChildren
  }
  
  subscript(description: AnyNodeDescription) -> Animation {
    if let props = description.anyProps as? Keyable, let key = props.key {
      return self[key]
    }
    
    return self.allChildren
  }
}
