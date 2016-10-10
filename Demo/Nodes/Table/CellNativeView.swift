//
//  CellNativeView.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit
import Katana

public class CellNativeView: UIView {
  var update: ((Bool) -> Void)?
  
  func setHighlighted(_ highlighted: Bool) {
    if let update = self.update {
      update(highlighted)
    }
  }
}
