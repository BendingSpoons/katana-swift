//
//  NSView+Utils.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Cocoa

// MARK: NSView + backgroundColor
public extension NSView {
  
  public var backgroundColor: NSColor? {
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

// MARK: NSView + customTag
import func ObjectiveC.objc_getAssociatedObject
import func ObjectiveC.objc_setAssociatedObject
import enum ObjectiveC.objc_AssociationPolicy
var key: ()?
extension NSView {
  var customTag: Int {
    get {
      return objc_getAssociatedObject(self, &key) as? Int ?? -1
    }
    set {
      objc_setAssociatedObject(self, &key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}
