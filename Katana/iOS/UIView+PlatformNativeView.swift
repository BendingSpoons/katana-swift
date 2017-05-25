//
//  UIView+PlatformNativeView.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

internal let VIEWTAG = 999987

/// An extension of UIView that implements the `DrawableContainer` protocol
extension UIView: PlatformNativeView {

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public var tagValue: Int {
    get {
      return self.tag
    }
    set {
      self.tag = newValue
    }
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public static func make() -> Self {
    return self.init()
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
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
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
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

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public func addToParent(parent: PlatformNativeView) {
    if let parent = parent as? UIView {
      parent.addSubview(self)
    }
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
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
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public func children () -> [PlatformNativeView] {
    return self.subviews.filter { $0.tagValue == VIEWTAG }
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
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
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
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
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public static func animate(type: AnimationType, _ block: @escaping ()->(), completion: (() -> ())?) {
    let animationCompletion = { (v: Bool) -> () in
      completion?()
    }

    switch type {
    case .none:
      block()
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
