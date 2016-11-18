//
//  KatanaEdgeInsets+UIEdgeInsets.swift
//  Katana
//
//  Created by Andrea De Angelis on 18/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public extension FloatEdgeInsets {
  public var uiEdgeInsets: UIEdgeInsets {
    return UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
  }
}
