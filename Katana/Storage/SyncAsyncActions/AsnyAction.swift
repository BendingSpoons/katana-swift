//
//  AsnyAction.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyAsyncAction : Action {
  static func anyReduce(state: State, action: AnyAsyncAction) -> State
  var state : AsyncActionState {get set}
}

public enum AsyncActionState {
  case loading, completed, failed
}

public protocol AsyncAction : Action, AnyAsyncAction {
  associatedtype LoadingPayloadType
  associatedtype CompletedPayloadType
  associatedtype FailedPayloadType
  associatedtype StateType
  
  var state : AsyncActionState {get set}
  
  var loadingPayload : LoadingPayloadType {get set}
  var completedPayload : CompletedPayloadType? {get set}
  var failedPayload : FailedPayloadType? {get set}

  static func loadingReduce(state: inout StateType, action: Self)
  static func completedReduce(state: inout StateType, action: Self)
  static func failedReduce(state: inout StateType, action: Self)
  
  func completedAction(payload: CompletedPayloadType) -> Self
  func failedAction(payload: FailedPayloadType) -> Self
  
  init(loadingPayload: LoadingPayloadType)
}

public extension AsyncAction {
  static func anyReduce(state: State, action: AnyAsyncAction) -> State {
    var state = state as! StateType
    let action = action as! Self
    
    switch action.state {
    
    case .loading:
      loadingReduce(state: &state, action: action)
      
    case .completed:
      completedReduce(state: &state, action: action)

    case .failed:
      failedReduce(state: &state, action: action)
    }
    
    return state as! State
  }
  
  func completedAction(payload: CompletedPayloadType) -> Self {
    var copy = self
    copy.completedPayload = payload
    copy.state = .completed
    return copy
  }
  
  func failedAction(payload: FailedPayloadType) -> Self {
    var copy = self
    copy.failedPayload = payload
    copy.state = .failed
    return copy
  }
  
}

public extension AsyncAction where Self : ActionWithSideEffect {
  
  static func anySideEffect(action: Action, getState: StoreGetState<State>, dispatch: StoreDispatch) {
    
    let action = action as! Self
    
    if action.state == .loading {
      
      func _getState() -> StateType{
        return getState() as! StateType
      }
      
      sideEffect(action: action, getState: _getState, dispatch: dispatch)
    }
  }
}
