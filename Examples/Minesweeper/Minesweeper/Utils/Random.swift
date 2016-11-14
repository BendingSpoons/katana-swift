//
//  Random.swift
//  Minesweeper
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import UIKit

// MARK: Random Int
extension Int {
  static func random(max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
  }
}

// MARK: Random CGFloat
extension CGFloat {
  static func random(max: Int) -> CGFloat {
    return CGFloat(arc4random_uniform(UInt32(max)))
  }
}

// MARK: Random UIColor
extension UIColor {
  static var randomColor: UIColor {
    return UIColor(red: CGFloat.random(max: 256) / 255.0,
                   green: CGFloat.random(max: 256) / 255.0,
                   blue: CGFloat.random(max: 256) / 255.0,
                   alpha: 1.0)
  }
}
