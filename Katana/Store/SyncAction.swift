//
//  SyncAction.swift
//  Katana
//
//  Created by Mauro Bolis on 28/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol SyncAction: Action {
  associatedtype StateType: State
  associatedtype Payload
  
  var payload: Payload { get }
  
  static func reduce(state: inout StateType, action: Self)
}

public extension SyncAction {
  static func reduce(state: State, action: Self) -> State {
    guard let s = state as? StateType,
          let a = action as? Self
      else {
        preconditionFailure("Given state or action are not compatible with the current action type")
    }
    
    var mutableState = s
    self.reduce(state: &mutableState, action: a)
    return mutableState
  }
}
