//
//  AsnyAction.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyAsyncSmartAction: Action {
  static func anyReduce(state: State, action: AnyAsyncSmartAction) -> State
  var state: AsyncSmartActionState {get set}
}

public enum AsyncSmartActionState {
  case loading, completed, failed
}

public protocol AsyncSmartAction: Action, AnyAsyncSmartAction {
  associatedtype LoadingPayloadType
  associatedtype CompletedPayloadType
  associatedtype FailedPayloadType
  associatedtype StateType
  
  var state: AsyncSmartActionState {get set}
  
  var loadingPayload: LoadingPayloadType {get set}
  var completedPayload: CompletedPayloadType? {get set}
  var failedPayload: FailedPayloadType? {get set}

  static func loadingReduce(state: inout StateType, action: Self)
  static func completedReduce(state: inout StateType, action: Self)
  static func failedReduce(state: inout StateType, action: Self)
  
  func completedAction(payload: CompletedPayloadType) -> Self
  func failedAction(payload: FailedPayloadType) -> Self
  
  init(loadingPayload: LoadingPayloadType)
}

public extension AsyncSmartAction {
  static func anyReduce(state: State, action: AnyAsyncSmartAction) -> State {
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

public extension AsyncSmartAction where Self: SmartActionWithSideEffect {
  
  
  
  static func anySideEffect(action: Action,
                            state: State,
                            dispatch: @escaping StoreDispatch,
                            dependencies: Any?) {
    
    let action = action as! Self
    let state = state as! StateType
    let dependencies = dependencies as! SideEffectsDependencies<Self.StateType>?
    
    if action.state == .loading {

      sideEffect(action: action, state: state, dispatch: dispatch, dependencies: dependencies)
    }

  }

}
