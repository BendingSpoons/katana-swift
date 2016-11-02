//
//  TableDelegate.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

public protocol TableDelegate {
  func numberOfSections() -> Int
  func numberOfRows(forSection section: Int) -> Int
  func cellDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription
  func height(forRowAt indexPath: IndexPath) -> Value
  func isEqual(to anotherDelegate: TableDelegate) -> Bool
}

public extension TableDelegate {
  func numberOfSections() -> Int {
    return 1
  }
}

public struct EmptyTableDelegate: TableDelegate {
  public func numberOfSections() -> Int {
    return 0
  }

  public func numberOfRows(forSection section: Int) -> Int {
    return 0
  }
  
  public func cellDescription(forRowAt indexPath: IndexPath) -> AnyNodeDescription {
    fatalError()
  }

  public func height(forRowAt indexPath: IndexPath) -> Value {
    fatalError()
  }
  
  public func isEqual(to anotherDelegate: TableDelegate) -> Bool {
    return anotherDelegate is EmptyTableDelegate
  }
}
