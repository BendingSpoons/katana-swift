//
//  TestNativeView.swift
//  Katana
//
//  Created by Andrea De Angelis on 18/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana
import CoreGraphics

class TestNativeView: PlatformNativeView {
  var frame: CGRect = .zero
  var alpha: CGFloat = 1.0
  var tag: Int = 0
  
  var childrenViews: [PlatformNativeView] = []
  
  required init() {}
  
  static func make() -> Self {
    return self.init()
  }
  
  func removeAllChildren() {
    
  }
  
  @discardableResult func addChild(_ child: () -> PlatformNativeView) -> PlatformNativeView {
    let c = child()
    childrenViews.append(c)
    return c
  }
  
  func addToParent(parent: PlatformNativeView) {
    return
  }
  
  func update(with updateView: (PlatformNativeView)->()) {
    updateView(self)
  }
  
  func children () -> [PlatformNativeView] {
    return self.childrenViews
  }
  
  func bringChildToFront(_ child: PlatformNativeView) {
    let index = self.childrenViews.index {
      $0 === child
    }
    if let index = index {
      self.childrenViews.remove(at: index)
      self.childrenViews.insert(child, at: 0)
    }
  }
  
  func removeChild(_ child: PlatformNativeView) {
    let index = self.childrenViews.index {
      $0 === child
    }
    if let index = index {
      self.childrenViews.remove(at: index)
    }
  }
}
