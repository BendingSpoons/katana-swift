//
//  DispatchingNode.swift
//  Katana
//
//  Created by Luca Querella on 03/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyDispatchingNodeDescription {
  static func anyRender(props: Any,
                     state: Any,
                     update: @escaping (Any)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription]
}

public protocol DispatchingNodeDescription : NodeDescription, AnyDispatchingNodeDescription {
  
  
  static func render(props: PropsType,
                     state: StateType,
                     update: @escaping (StateType)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription]
  
}

public extension NodeDescription where Self: DispatchingNodeDescription {
    
  static func render(props: PropsType,
                     state: StateType,
                     update: @escaping (StateType)->()) -> [AnyNodeDescription] {
    
    fatalError("this method is never called by the framework on DispatchingNodeDescription")
  }
}

public extension AnyDispatchingNodeDescription where Self: DispatchingNodeDescription {
  
  static func anyRender(props: Any,
                        state: Any,
                        update: @escaping (Any)->(),
                        dispatch: StoreDispatch) -> [AnyNodeDescription] {
    
    let state = state as! StateType
    let props = props as! PropsType

    return render(props: props, state: state, update: update, dispatch: dispatch)
  }
}
