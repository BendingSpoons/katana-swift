//
//  NativeButton.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

public typealias ClickHandlerClosure = (NativeButton) -> ()

open class NativeButton: NSButton {

  // MARK: - backgroundColor

  open var backgroundColor: NSColor = NSColor.white {
    didSet {
      self.needsDisplay = true
    }
  }

  open var backgroundHighlightedColor: NSColor = NSColor.white {
    didSet {
      self.needsDisplay = true
    }
  }
  
  open var borderColor: NSColor = NSColor.clear {
    didSet {
      self.needsDisplay = true
    }
  }
  
  open var borderWidth: CGFloat = 0 {
    didSet {
      self.needsDisplay = true
    }
  }
  
  open var cornerRadius: CGFloat = 0 {
    didSet {
      self.needsDisplay = true
    }
  }

  // MARK: - clickHandler

  open var clickHandler: ClickHandlerClosure? {
    didSet {
      updateTarget()
    }
  }

  private func updateTarget() {
    self.target = self
    self.action = #selector(click)
  }

  @objc private func click() {
    clickHandler?(self)
  }

  // MARK: - updates

  open override var wantsUpdateLayer: Bool {
    return true
  }

  open override func updateLayer() {
    if let cell = self.cell, cell.isHighlighted {
      self.layer?.backgroundColor = self.backgroundHighlightedColor.cgColor
    } else {
      self.layer?.backgroundColor = self.backgroundColor.cgColor
    }
    self.layer?.borderColor = self.borderColor.cgColor
    self.layer?.borderWidth = self.borderWidth
    self.layer?.cornerRadius = self.cornerRadius
  }

  // MARK: - coordinate system

  // In Katana macOS we stick with the iOS coordinate system
  open override var isFlipped: Bool {
    return true
  }

}
