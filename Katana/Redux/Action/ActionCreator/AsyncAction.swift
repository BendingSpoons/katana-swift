//
//  AsyncAction.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

enum AsyncActionState {
  case Loading, Completed, Error
}

struct AsyncAction<Payload, CompletedPayload, ErrorPayload>: Action {
  let payload: Payload?
  let completedPayload: CompletedPayload?
  let errorPayload: ErrorPayload?
  let state: AsyncActionState
  private(set) var actionName: String
  
  private init(actionName: String, payload: Payload) {
    self.actionName = actionName
    self.payload = payload
    self.completedPayload = nil
    self.errorPayload = nil
    self.state = .Loading
  }
  
  private init(actionName: String, completedPayload: CompletedPayload) {
    self.actionName = actionName
    self.payload = nil
    self.completedPayload = completedPayload
    self.errorPayload = nil
    self.state = .Completed
  }
  
  private init(actionName: String, errorPayload: ErrorPayload) {
    self.actionName = actionName
    self.payload = nil
    self.completedPayload = nil
    self.errorPayload = errorPayload
    self.state = .Error
  }
  
  func completedAction(payload: CompletedPayload) -> AsyncAction<Payload, CompletedPayload, ErrorPayload> {
    assert(self.state == .Loading, "Cannot Invoked this method on actions that are not in the loading state")
    return self.dynamicType.init(actionName: self.actionName, completedPayload: payload)
  }
  
  func errorAction(payload: ErrorPayload) -> AsyncAction<Payload, CompletedPayload, ErrorPayload> {
    assert(self.state == .Loading, "Cannot Invoked this method on actions that are not in the loading state")
    return self.dynamicType.init(actionName: self.actionName, errorPayload: payload)
  }
}

struct AsyncActionCreator<Payload, CompletedPayload, ErrorPayload> {
  let actionName: String
  
  public init(withName name: String) {
    actionName = name
  }
  
  func with(payload: Payload) -> AsyncAction<Payload, CompletedPayload, ErrorPayload> {
    return AsyncAction<Payload, CompletedPayload, ErrorPayload>(actionName: self.actionName, payload: payload)
  }
}
