//
//  SyncAction.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public struct SyncAction<Payload>: Action {
  public let payload: Payload
  public private(set) var actionName: String
  
  private init(actionName: String, payload: Payload) {
    self.actionName = actionName
    self.payload = payload
  }
}

public struct SyncActionCreator<Payload> {
  public let actionName: String
  
  public init(withName name: String) {
    actionName = name
  }
  
  public func with(payload: Payload) -> SyncAction<Payload> {
    return SyncAction<Payload>(actionName: self.actionName, payload: payload)
  }
}
