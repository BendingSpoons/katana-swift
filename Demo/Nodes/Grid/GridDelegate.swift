//
//  GridDelegate.swift
//  Katana
//
//  Created by Mauro Bolis on 23/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

public protocol GridDelegate {
  func numberOfSections() -> Int
  func numberOfRows(forSection section: Int) -> Int
  func nodeDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription
}

public extension GridDelegate {
  func numberOfSections() -> Int {
    return 1
  }
}

struct EmptyGridDelegate: GridDelegate {
  func numberOfSections() -> Int {
    return 0
  }
  
  func numberOfRows(forSection section: Int) -> Int {
    return 0
  }
  
  func nodeDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription {
    fatalError()
  }
}
