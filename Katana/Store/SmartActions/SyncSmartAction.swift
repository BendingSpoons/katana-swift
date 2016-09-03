//
//  SyncSmartAction.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnySyncSmartAction : Action {
  static func anyReduce(state: State, action: AnySyncSmartAction) -> State
}

public protocol SyncSmartAction : Action, AnySyncSmartAction {
  associatedtype PayloadType
  associatedtype StateType
  
  var payload : PayloadType {get set}
  
  static func reduce(state: inout StateType, action: Self)
}

public extension SyncSmartAction {
  static func anyReduce(state: State, action: AnySyncSmartAction) -> State {
    var state = state as! StateType
    let action = action as! Self
    
    reduce(state: &state, action: action)
    
    return state as! State
  }
  
}

public extension SyncSmartAction where Self : SmartActionWithSideEffect {
  
    
    static func anySideEffect(action: Action,
                              state: State,
                              dispatch: StoreDispatch,
                              dependencies: Any?) {
      
      let action = action as! Self
      let state = state as! StateType
      let dependencies = dependencies as! SideEffectsDependencies<Self.StateType>?
      
      
      sideEffect(action: action, state: state, dispatch: dispatch, dependencies: dependencies)
      
    }
}
