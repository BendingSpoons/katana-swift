//
//  NSAttributedString+Stykes.swift
//  PokeAnimations
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import UIKit

extension NSAttributedString {
  static func buttonTitleString(_ content: String, for state: UIControlState) -> NSAttributedString {

    let color = state.contains(.highlighted)
    ? UIColor(white: 0, alpha: 0.3)
    : UIColor.black

    return NSAttributedString(string: content, attributes: [
      NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 20.0)!,
      NSForegroundColorAttributeName: color
    ])
  }
  
  static func paragraphString(_ content: String) -> NSAttributedString {
    return NSAttributedString(string: content, attributes: [
      NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 25.0)!,
      NSForegroundColorAttributeName: UIColor(white: 0, alpha: 0.5)
    ])
  }
}
