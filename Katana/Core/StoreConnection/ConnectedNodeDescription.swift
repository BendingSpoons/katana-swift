//
//  ConnectedNodeDescription.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyConnectedNodeDescription {
  static func anyConnect(parentProps: Any, storeState: Any) -> Any
}

public protocol ConnectedNodeDescription: AnyConnectedNodeDescription {
  associatedtype PropsType: NodeProps = EmptyProps
  associatedtype StoreState: State

  static func connect(props: inout PropsType, to storeState: StoreState)
}

public extension ConnectedNodeDescription {
  static func anyConnect(parentProps: Any, storeState: Any) -> Any {
    
    guard let parentProps = parentProps as? PropsType, let s = storeState as? StoreState else {
      fatalError("invalid signature of the connect function of \(type(of: self))")
    }
    
    var parentPropsCopy = parentProps
    self.connect(props: &parentPropsCopy, to: s)
    return parentPropsCopy

  }
}
