//
//  DrawableContainer.swift
//  Katana
//
//  Created by Luca Querella on 07/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

/// Protocol that is used to describe `DrawableContainer` children
public protocol DrawableContainerChild {}

/**
 This protocol abstracts how `Node` instances can be rendered. We have introduced this protocol
 to abstract the Katana world (nodes and descriptions) from the underlying implementation of how
 the UI is rendered.
 
 The most obvious implementation of this protocol is `UIView`. It is possible to create custom containers
 that renders nodes on abstract structures (e.g., for testing) or on serializable structures to store the UI
 representation and use it later.
 
 - note: We are not currently leveraging this abstraction and it very likely that we will need to work and further improve
         this protocol in order to use it for meaningful purpose. For instance the signatures 
         are havily binded to UIView instances, which defeats the entire purpose of this protocol.
*/
public protocol DrawableContainer {
  /**
    Removes all the children from the container

    - warning: this method should be invoked in the main queue
  */
  func removeAllChildren()
  
  /**
   Adds a child to the container
   
   - parameter child: a closure that returns the UIView to add to the container
   - returns: the container that holds the child
   
   - warning: this method should be invoked in the main queue
  */
  @discardableResult func addChild(_ child: () -> UIView) -> DrawableContainer
  
  /**
   Updates the description
   
   - parameter updateView: a closure that takes as input the UIView represented by the container and
                           updates it
   
   - warning: this method should be invoked in the main queue
  */
  func update(with updateView: (UIView)->())
  
  /// Returns the children of the container
  func children () -> [DrawableContainerChild]
  
  /**
    Moves to the front a child
    
    - parameter child: the child to move to the front
  */
  func bringChildToFront(_ child: DrawableContainerChild)
  
  /**
   Removes a child
   
   - parameter child: the child to remove
  */
  func removeChild(_ child: DrawableContainerChild)
}

internal let VIEWTAG = 999987

/// An extension of UIView that implements the `DrawableContainer` protocol
extension UIView: DrawableContainer {
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
  public func addChild(_ child: () -> UIView) -> DrawableContainer {
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
  
  /**
   Implementation of the DrawableContainer protocol.
   
   - seeAlso: `DrawableContainer`
  */
  public func update(with updateView: (UIView)->()) {
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
