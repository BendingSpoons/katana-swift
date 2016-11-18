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
extension UIView: DrawableContainer {
  
  public static func make() -> Self {
    return self.init()
  }
  
  /// A struct that implements the `DrawableContainerChild` protocol
  public struct UIViewDrawableContainerChild: DrawableContainerChild {
    /// the child view
    private(set) var view: UIView
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
  public func addChild(_ child: () -> DrawableContainer) -> DrawableContainer {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    
    let child = child()
    child.tag = VIEWTAG
    
    child.addToParent(parent: self)
    return child
  }
  
  public func addToParent(parent: DrawableContainer) {
    if let parent = parent as? UIView {
      parent.addSubview(self)
    }
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func update(with updateView: (DrawableContainer)->()) {
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
  public func children () -> [DrawableContainerChild] {
    return self.subviews.filter {$0.tag == VIEWTAG}.map { UIViewDrawableContainerChild(view: $0) }
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func bringChildToFront(_ child: DrawableContainerChild) {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    let child = child as! UIViewDrawableContainerChild
    self.bringSubview(toFront: child.view)
  }
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
   */
  public func removeChild(_ child: DrawableContainerChild) {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    let child = child as! UIViewDrawableContainerChild
    child.view.removeFromSuperview()
  }
}
