//
//  TouchHandlerEvent.swift
//  Katana
//
//  Created by Mauro Bolis on 14/10/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public struct TouchHandlerEvent: OptionSet, Hashable {
  public let rawValue: Int
  
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  
  public static var touchDown = TouchHandlerEvent(rawValue: 1 << 0)
  public static var touchUpInside = TouchHandlerEvent(rawValue: 1 << 1)
  public static var touchUpOutside = TouchHandlerEvent(rawValue: 1 << 2)
  public static var touchCancel = TouchHandlerEvent(rawValue: 1 << 3)
  
  public var hashValue: Int {
    return self.rawValue
  }
}
