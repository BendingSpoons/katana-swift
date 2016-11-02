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
  associatedtype LoadingPayload
  associatedtype CompletedPayload
  associatedtype FailedPayload
  
  var state: AsyncActionState { get set }
  var loadingPayload: LoadingPayload { get set }
  var completedPayload: CompletedPayload? { get set }
  var failedPayload: FailedPayload? { get set }
  
  static func loadingReduce(state: State, action: Self) -> State
  static func completedReduce(state: State, action: Self) -> State
  static func failedReduce(state: State, action: Self) -> State
  
  init(payload: LoadingPayload)

  func completedAction(payload: CompletedPayload) -> Self
  func failedAction(payload: FailedPayload) -> Self
}

public extension AsyncAction {
  public static func reduce(state: State, action: Self) -> State {
    switch action.state {
    case .loading:
      return self.loadingReduce(state: state, action: action)
      
    case .completed:
      return self.completedReduce(state: state, action: action)
      
    case .failed:
      return self.failedReduce(state: state, action: action)
    }
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
