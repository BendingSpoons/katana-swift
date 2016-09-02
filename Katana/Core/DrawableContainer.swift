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
  
  func update(view: (UIView)->())
  
  func children () -> [DrawableContainerChild]
  
  func bringToFront(child: DrawableContainerChild)
  
  func remove(child: DrawableContainerChild)
}

internal let VIEW_TAG = 999987

extension UIView : DrawableContainer {
  public struct UIViewDrawableContainerChild : DrawableContainerChild {
    private(set) var view : UIView
  }
  
  public func removeAll() {
    dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

    self.subviews
      .filter { $0.tag == VIEW_TAG }
      .forEach { $0.removeFromSuperview() }
  }
  
  public func add(child: () -> UIView) -> DrawableContainer {
    dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

    let child = child()
    child.tag = VIEW_TAG
    self.addSubview(child)
    return child
  }
  
  public func update(view: (UIView)->()) {
    dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
    view(self)
  }
  
  public func children () -> [DrawableContainerChild] {
    return self.subviews.filter {$0.tag == VIEW_TAG}.map { UIViewDrawableContainerChild(view: $0) }
  }
  
  public func bringToFront(child: DrawableContainerChild) {
    dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

    let child = child as! UIViewDrawableContainerChild
    self.bringSubview(toFront: child.view)
  }
  
  public func remove(child: DrawableContainerChild) {
    dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

    let child = child as! UIViewDrawableContainerChild
    child.view.removeFromSuperview()
  }
}
