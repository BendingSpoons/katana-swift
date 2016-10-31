//
//  UIColor+Demo.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  convenience public init(_ hex: Int) {
    let red = (hex >> 16) & 0xff
    let green = (hex >> 8) & 0xff
    let blue = hex & 0xff
    
    
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0,
              green: CGFloat(green) / 255.0,
              blue: CGFloat(blue) / 255.0,
              alpha: 1.0)
  }
}
