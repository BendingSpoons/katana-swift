//
//  UIView+PlatformNativeView.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana
import UIKit

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
  
  /**
   Animates UI changes performed in a block with the animation specified by the AnimationType
   - parameter type: the type of the animation
   - parameter block: a block that contains the updates to the UI to animate
   - parameter completion: a block that is called when the animation completes
   */
  public static func animate(type: AnimationType, _ block: @escaping ()->(), completion: (() -> ())?) {
    let animationCompletion = { (v: Bool) -> () in
      completion?()
    }
    
    switch type {
    case .none:
      UIView.performWithoutAnimation(block)
      completion?()
      
    case let .linear(duration):
      UIView.animate(withDuration: duration,
                     delay: 0,
                     options: [],
                     animations: block,
                     completion: animationCompletion)
      
    case let .linearWithOptions(duration, options):
      UIView.animate(withDuration: duration,
                     delay: 0,
                     options: options.toUIViewAnimationOptions,
                     animations: block,
                     completion: animationCompletion)
      
    case let .linearWithDelay(duration, options, delay):
      UIView.animate(withDuration: duration,
                     delay: delay,
                     options: options.toUIViewAnimationOptions,
                     animations: block,
                     completion: animationCompletion)
      
    case let .spring(duration, damping, initialVelocity):
      UIView.animate(withDuration: duration,
                     delay: 0,
                     usingSpringWithDamping: damping,
                     initialSpringVelocity: initialVelocity,
                     options: .curveEaseInOut,
                     animations: block,
                     completion: animationCompletion)
      
    case let .springWithOptions(duration, damping, initialVelocity, options):
      UIView.animate(withDuration: duration,
                     delay: 0,
                     usingSpringWithDamping: damping,
                     initialSpringVelocity: initialVelocity,
                     options: options.toUIViewAnimationOptions,
                     animations: block,
                     completion: animationCompletion)
      
    case let .springWithDelay(duration, damping, initialVelocity, options, delay):
      UIView.animate(withDuration: duration,
                     delay: delay,
                     usingSpringWithDamping: damping,
                     initialSpringVelocity: initialVelocity,
                     options: options.toUIViewAnimationOptions,
                     animations: block,
                     completion: animationCompletion)
    }
  }
}
