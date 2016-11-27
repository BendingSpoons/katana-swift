//
//  NativeButton.swift
//  Katana
//
//  Created by Andrea De Angelis on 27/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import AppKit

public class NativeButton: NSButton {
  override public var wantsUpdateLayer: Bool {
    return true
  }
  
  public var clickHandler: ClickHandlerClosure? {
    didSet {
      updateTarget()
    }
  }
  
  private func updateTarget() {
    self.target = self
    self.action = #selector(click)
  }
  
  @objc private func click() {
    clickHandler?()
  }
  
  public var backgroundNormalColor: NSColor = .white
  public var backgroundHighlightedColor: NSColor = .white
  
  override public func updateLayer() {
    if let cell = self.cell, cell.isHighlighted {
      self.backgroundColor = backgroundHighlightedColor
    } else {
      self.backgroundColor = backgroundNormalColor
    }
  }
}
