//
//  NSView+PlatformNativeView.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import AppKit

internal let VIEWTAG = 999987

/**
 An extension of NSView that implements the `PlatformNativeView` protocol
 - seeAlso: `PlatformNativeView`
 */

extension NSView: PlatformNativeView {

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public var alpha: CGFloat {
    get {
      return self.alphaValue
    }
    set {
      self.alphaValue = newValue
    }
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public var tagValue: Int {
    get {
      return self.customTag
    }
    set {
      self.customTag = newValue
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
    if #available(macOS 10.12, *) {
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
    if #available(macOS 10.12, *) {
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
    if let parent = parent as? NSView {
      parent.addSubview(self)
    }
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public func update(with updateView: (PlatformNativeView)->()) {
    if #available(macOS 10.12, *) {
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
    let subviews = self.subviews.filter {
      $0.tagValue == VIEWTAG
    }
    return subviews
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public func bringChildToFront(_ child: PlatformNativeView) {
    if #available(macOS 10.12, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

    } else {
      assert(Thread.isMainThread)
    }

    let child = child
    if let child = child as? NSView {
      // equivalent of UIView.bringSubviewToFront:
      child.removeFromSuperview()
      self.addSubview(child)
    }
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public func removeChild(_ child: PlatformNativeView) {
    if #available(macOS 10.12, *) {
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
    } else {
      assert(Thread.isMainThread)
    }
    if let child = child as? NSView {
      child.removeFromSuperview()
    }
  }

  /**
   Implementation of the PlatformNativeView protocol.
   
   - seeAlso: `PlatformNativeView`
   */
  public static func animate(type: AnimationType, _ block: @escaping ()->(), completion: (() -> ())?) {
    block()
    completion?()
  }
}
