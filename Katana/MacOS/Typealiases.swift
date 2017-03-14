//
//  DefaultView.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import AppKit
public typealias DefaultView = NSViewCustom
public typealias FloatEdgeInsets = Foundation.EdgeInsets
public typealias Screen = NSScreen

extension NSScreen {
  static var retinaScale: CGFloat {
    return NSScreen.main()!.backingScaleFactor
  }
}
