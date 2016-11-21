//
//  NSView+Utils.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Cocoa

extension NSView {
  
  var backgroundColor: NSColor? {
    get {
      if let colorRef = self.layer?.backgroundColor {
        return NSColor(cgColor: colorRef)
      } else {
        return nil
      }
    }
    set {
      self.wantsLayer = true
      self.layer?.backgroundColor = newValue?.cgColor
    }
  }
}
