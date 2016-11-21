//
//  KatanaEdgeInsets+UIEdgeInsets.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

public extension FloatEdgeInsets {
  public var uiEdgeInsets: UIEdgeInsets {
    return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
  }
}
