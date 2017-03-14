//
//  Typealiases.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

public typealias DefaultView = UIView
public typealias FloatEdgeInsets = UIEdgeInsets
public typealias Screen = UIScreen

extension UIScreen {
  static var retinaScale: CGFloat {
    return UIScreen.main.scale
  }
}
