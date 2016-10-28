//
//  AsyncAction.swift
//  Katana
//
//  Created by Mauro Bolis on 28/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public enum AsyncActionState {
  case loading, completed, failed
}

public protocol AsyncAction: Action {
  associatedtype StateType: State
  associatedtype LoadingPayload
  associatedtype CompletedPayload
  associatedtype FailedPayload
  
  var state: AsyncActionState { get set }
  var loadingPayload: LoadingPayload { get set }
  var completedPayload: CompletedPayload? { get set }
  var failedPayload: FailedPayload? { get set }
  
  static func loadingReduce(state: inout StateType, action: Self)
  static func completedReduce(state: inout StateType, action: Self)
  static func failedReduce(state: inout StateType, action: Self)
  
  init(payload: LoadingPayload)

  func completedAction(payload: CompletedPayload) -> Self
  func failedAction(payload: FailedPayload) -> Self
}

public extension AsyncAction {
  public static func reduce(state: State, action: Self) -> State {
    guard let s = state as? StateType else {
      preconditionFailure("Given state or action are not compatible with the current action type")
    }
    
    var mutableState = s
    
    switch action.state {
    case .loading:
      self.loadingReduce(state: &mutableState, action: action)
      
    case .completed:
      self.completedReduce(state: &mutableState, action: action)
      
    case .failed:
      self.failedReduce(state: &mutableState, action: action)
    }
    
    return mutableState
  }
  
  public func completedAction(payload: CompletedPayload) -> Self {
    var copy = self
    copy.completedPayload = payload
    copy.state = .completed
    return copy
  }

  public func failedAction(payload: FailedPayload) -> Self {
    var copy = self
    copy.failedPayload = payload
    copy.state = .failed
    return copy
  }
}
