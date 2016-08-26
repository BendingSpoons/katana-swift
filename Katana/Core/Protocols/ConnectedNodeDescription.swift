//
//  ConnectedNodeDescription.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyConnectedNodeDescription {
  static func anyConnect(parentProps: Any, storageState: Any) -> Any
}

public protocol ConnectedNodeDescription: AnyConnectedNodeDescription {
  associatedtype Props: Equatable, Frameable
  associatedtype StorageState: State

  static func connect(parentProps: Props, storageState: StorageState) -> Props
}

public extension ConnectedNodeDescription {
  static func anyConnect(parentProps: Any, storageState: Any) -> Any {
    if let p = parentProps as? Props, let s = storageState as? StorageState {
      return self.connect(parentProps: p, storageState: s)
    }
    
    fatalError("invalid signature of the connect function of \(self.dynamicType)")
  }
}
