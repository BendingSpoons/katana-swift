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

public protocol SyncSmartAction : Action {
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
  static func anySideEffect(action: Action, getState: StoreGetState<State>, dispatch: StoreDispatch) {
    
    let action = action as! Self
    
    func _getState() -> StateType{
      return getState() as! StateType
    }
    
    sideEffect(action: action, getState: _getState, dispatch: dispatch)
  }
}


