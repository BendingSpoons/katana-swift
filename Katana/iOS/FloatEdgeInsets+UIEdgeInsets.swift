//
//  FloatEdgeInsets+UIEdgeInsets.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.


public extension FloatEdgeInsets {
  public var toUIEdgeInsets: UIEdgeInsets {
    return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
  }
}
