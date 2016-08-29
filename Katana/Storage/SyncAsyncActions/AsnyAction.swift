//
//  AsnyAction.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyAsyncAction : Action {
  static func anyReduce( state: State, action: AnyAsyncAction) -> State
}

public enum AsyncActionState {
  case loading, completed, failed
}

public protocol AsyncAction : Action, AnyAsyncAction {
  associatedtype LoadingPayloadType
  associatedtype CompletedPayloadType
  associatedtype FailedPayloadType
  associatedtype StateType
  
  var state : AsyncActionState {get}
  
  var loadingPayload : LoadingPayloadType {get}
  var completedPayload : CompletedPayloadType {get}
  var failedPayload : FailedPayloadType {get}
  
  static func loadingReduce( state: inout StateType, action: Self)
  static func completedReduce( state: inout StateType, action: Self)
  static func failedReduce( state: inout StateType, action: Self)

}

public extension AsyncAction {
  
  static var name : String {
    return "\(type(of: self))"
  }
  
  static func anyReduce( state: State, action: AnyAsyncAction) -> State {
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
  
}
