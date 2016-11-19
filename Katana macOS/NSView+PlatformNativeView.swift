//
//  NSView+PlatformNativeView.swift
//  Katana
//
//  Created by Andrea De Angelis on 18/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana
import AppKit

internal let VIEWTAG = 999987

/// An extension of UIView that implements the `DrawableContainer` protocol
extension NSView: PlatformNativeView {
  
  public var alpha: CGFloat {
    get {
      return self.alphaValue
    }
    set {
      self.alphaValue = newValue
    }
  }
  
  public var tagValue: Int {
    get {
      return self.customTag.intValue
    }
    set {
      self.customTag = NSNumber(value: newValue)
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
      .filter { $0.tag == VIEWTAG }
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
    if let parent = parent as? NSView {
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
    /*let subviews = self.subviews.filter {
      $0.tag == VIEWTAG
    }
    return subviews
     */
    return self.subviews
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
    if let child = child as? NSView {
      self.bringChildToFront(child)
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
    if let child = child as? NSView {
      child.removeFromSuperview()
    }
  }
}

import ObjectiveC
var AssociatedObjectHandle: UInt8 = 0
extension NSView {
  var customTag: NSNumber {
    get {
      return objc_getAssociatedObject(self, &AssociatedObjectHandle) as! NSNumber
    }
    set {
      objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
