//
//  UIView+DrawableContainer.swift
//  Katana
//
//  Created by Andrea De Angelis on 18/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

internal let VIEWTAG = 999987

/// An extension of UIView that implements the `DrawableContainer` protocol
extension UIView: PlatformNativeView {
  
  public var tagValue: Int {
    get {
      return self.tag
    }
    set {
      self.tag = newValue
    }
  }
  
  public static func make() -> Self {
    return self.init()
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func removeAllChildren() {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    self.subviews
      .filter { $0.tagValue == VIEWTAG }
      .forEach { $0.removeFromSuperview() }
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func addChild(_ child: () -> PlatformNativeView) -> PlatformNativeView {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    
    let child = child()
    child.tagValue = VIEWTAG

    child.addToParent(parent: self)
    
    return child
  }
  
  public func addToParent(parent: PlatformNativeView) {
    if let parent = parent as? UIView {
      parent.addSubview(self)
    }
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func update(with updateView: (PlatformNativeView)->()) {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    updateView(self)
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func children () -> [PlatformNativeView] {
    return self.subviews.filter {$0.tagValue == VIEWTAG}
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func bringChildToFront(_ child: PlatformNativeView) {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    let child = child
    if let child = child as? UIView {
      self.bringSubview(toFront: child)
    }
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func removeChild(_ child: PlatformNativeView) {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    if let child = child as? UIView {
      child.removeFromSuperview()
    }
  }
}
