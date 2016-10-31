//
//  DrawableContainer.swift
//  Katana
//
//  Created by Luca Querella on 07/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol DrawableContainerChild {}

public protocol DrawableContainer {
  
  func removeAll()
  
  func add(child: () -> UIView) -> DrawableContainer
  
  func update(with updateView: (UIView)->())
  
  func children () -> [DrawableContainerChild]
  
  func bringToFront(child: DrawableContainerChild)
  
  func remove(child: DrawableContainerChild)
}

internal let VIEWTAG = 999987

extension UIView: DrawableContainer {
  
  public struct UIViewDrawableContainerChild: DrawableContainerChild {
    private(set) var view: UIView
  }
  
  public func removeAll() {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
    
    } else {
      assert(Thread.isMainThread)
    }

    self.subviews
      .filter { $0.tag == VIEWTAG }
      .forEach { $0.removeFromSuperview() }
  }
  
  public func add(child: () -> UIView) -> DrawableContainer {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    let child = child()
    child.tag = VIEWTAG
    self.addSubview(child)
    return child
  }
  
  public func update(with updateView: (UIView)->()) {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    updateView(self)
  }
  
  public func children () -> [DrawableContainerChild] {
    return self.subviews.filter {$0.tag == VIEWTAG}.map { UIViewDrawableContainerChild(view: $0) }
  }
  
  public func bringToFront(child: DrawableContainerChild) {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }

    let child = child as! UIViewDrawableContainerChild
    self.bringSubview(toFront: child.view)
  }
  
  public func remove(child: DrawableContainerChild) {
    if #available(iOS 10.0, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      
    } else {
      assert(Thread.isMainThread)
    }
    
    let child = child as! UIViewDrawableContainerChild
    child.view.removeFromSuperview()
  }
}
