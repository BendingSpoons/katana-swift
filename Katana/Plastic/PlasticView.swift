//
//  PlasticView.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public class PlasticView {
  private(set) var frame: CGRect
  private(set) var absoluteOrigin: CGPoint
  public let key: String
  
  convenience init(key: String) {
    self.init(key: key, frame: CGRect.zero)
  }
  
  init(key: String, frame: CGRect) {
    self.key = key
    self.frame = frame
    self.absoluteOrigin = CGPoint.zero
  }
}
