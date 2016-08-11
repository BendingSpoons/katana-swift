//
//  SyncAction.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

struct SyncAction<Payload>: Action {
  let payload: Payload?
  private(set) var actionName: String
  
  private init(actionName: String, payload: Payload) {
    self.actionName = actionName
    self.payload = payload
  }
}

struct SyncActionCreator<Payload> {
  let actionName: String
  
  public init(withName name: String) {
    actionName = name
  }
  
  func with(payload: Payload) -> SyncAction<Payload> {
    return SyncAction<Payload>(actionName: self.actionName, payload: payload)
  }
}
