//
//  AnimationOptions+UIViewAnimationOptions.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

public extension AnimationOptions {
  public var toUIViewAnimationOptions: UIViewAnimationOptions {
    return UIViewAnimationOptions(rawValue: self.rawValue)
  }
}
