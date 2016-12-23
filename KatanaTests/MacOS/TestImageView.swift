//
//  TestImageView.swift
//  Katana
//
//  Created by Andrea De Angelis on 28/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//
import AppKit

public class TestImageView: NSImageView {

  public var backgroundColor: NSColor = NSColor.white {
    didSet {
      self.needsDisplay = true
    }
  }

  override public var wantsUpdateLayer: Bool {
    return true
  }

  override public func updateLayer() {
    self.layer?.backgroundColor = self.backgroundColor.cgColor
  }
}
