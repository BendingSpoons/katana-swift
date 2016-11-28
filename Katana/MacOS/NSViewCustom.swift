//
//  NSViewCustom.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

public class NSViewCustom: NSView {
  
  // In Katana macOS we stick with the iOS coordinate system
  override public var isFlipped: Bool {
    return true
  }
  
  public var backgroundColor: NSColor = NSColor.white {
    didSet {
      self.needsDisplay = true
    }
  }
  
  public var cornerRadius: CGFloat = 0 {
    didSet {
      self.needsDisplay = true
    }
  }
  
  public var borderColor: NSColor = NSColor.black {
    didSet {
      self.needsDisplay = true
    }
  }
  
  public var borderWidth: CGFloat = 0.0 {
    didSet {
      self.needsDisplay = true
    }
  }
  
  override public var wantsUpdateLayer: Bool {
    return true
  }
  
  override public func updateLayer() {
    self.layer?.backgroundColor = self.backgroundColor.cgColor
    self.layer?.cornerRadius = self.cornerRadius
    self.layer?.borderColor = self.borderColor.cgColor
    self.layer?.borderWidth = self.borderWidth
  }
  
  
}
