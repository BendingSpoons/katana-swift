//
//  NSView+Utils.swift
//  Katana
//
//  Created by Andrea De Angelis on 18/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

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
