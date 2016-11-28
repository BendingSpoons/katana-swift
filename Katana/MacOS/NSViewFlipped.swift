//
//  NSViewFlipped.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

public class NSViewFlipped: NSView {
  
  // In Katana macOS we stick with the iOS coordinate system
  override public var isFlipped: Bool {
    return true
  }
}
