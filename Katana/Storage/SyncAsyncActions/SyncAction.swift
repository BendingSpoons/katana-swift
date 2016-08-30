//
//  SyncAction.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnySyncAction : Action {

  static func anyReduce(state: State, action: AnySyncAction) -> State
  static func anySaga(action: AnySyncAction, state: State, dispatch: StoreDispatch)

}

public protocol SyncAction : Action, AnySyncAction {
  associatedtype PayloadType
  associatedtype StateType
  
  var payload : PayloadType {get set}
  

  static func reduce(state: inout StateType, action: Self)
  
  static func saga(action: Self, state: StateType, dispatch: StoreDispatch)

}

public extension SyncAction {
  static func anyReduce(state: State, action: AnySyncAction) -> State {
    var state = state as! StateType
    let action = action as! Self
    
    reduce(state: &state, action: action)
    
    return state as! State
  }

  
  static func anySaga(action: AnySyncAction, state: State, dispatch: StoreDispatch) {
    let state = state as! StateType
    let action = action as! Self

    saga(action: action, state: state, dispatch: dispatch)

  }
  
  static func saga(action: Self, state: StateType, dispatch: StoreDispatch) {
    
  }

}
