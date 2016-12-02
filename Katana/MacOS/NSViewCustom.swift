//
//  NSViewCustom.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

open class NSViewCustom: NSView {
  
  // In Katana macOS we stick with the iOS coordinate system
  open override var isFlipped: Bool {
    return true
  }
  
  open var backgroundColor: NSColor = NSColor.white {
    didSet {
      self.needsDisplay = true
    }
  }
  
  open var cornerRadius: CGFloat = 0 {
    didSet {
      self.needsDisplay = true
    }
  }
  
  open var borderColor: NSColor = NSColor.black {
    didSet {
      self.needsDisplay = true
    }
  }
  
  open var borderWidth: CGFloat = 0.0 {
    didSet {
      self.needsDisplay = true
    }
  }
  
  open override var wantsUpdateLayer: Bool {
    return true
  }

  open override func updateLayer() {
    self.layer?.backgroundColor = self.backgroundColor.cgColor
    self.layer?.cornerRadius = self.cornerRadius
    self.layer?.borderColor = self.borderColor.cgColor
    self.layer?.borderWidth = self.borderWidth
  }

}
