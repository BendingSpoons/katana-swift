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
  associatedtype PropsType: NodeProps = EmptyProps
  associatedtype StorageState: State

  static func connect(props: inout PropsType, to storageState: StorageState)
}

public extension ConnectedNodeDescription {
  static func anyConnect(parentProps: Any, storageState: Any) -> Any {
    
    guard let parentProps = parentProps as? PropsType, let s = storageState as? StorageState else {
      fatalError("invalid signature of the connect function of \(type(of: self))")
    }
    
    var parentPropsCopy = parentProps
    self.connect(props: &parentPropsCopy, to: s)
    return parentPropsCopy

  }
}
