//
//  NSParagraphStyle+Katana.swift
//  Katana
//
//  Created by Luca Querella on 15/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

extension NSParagraphStyle {
  
  public static var centerAlignment: NSParagraphStyle {
    get {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      return paragraphStyle
    }
  }
  
}
