//
//  Action.swift
//  Katana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

/// Type Erasure for `Action`
public protocol AnyAction {
  
  /**
   Creates a new state starting from the current state and an action
   
   - seeAlso: `Action`, `reduce(state:action:)` method
  */
  static func anyReduce(state: State, action: AnyAction) -> State
}

/**
 An action represents an event that leads to a change in the state of the application.
 It can be triggered from an user action, from a system event or any event in general.
 
 In general this protocol should not be used directly. Use `SyncAction` and `AsyncAction` instead
*/
public protocol Action: AnyAction {
  /**
   Creates the new state starting from the current state and the action
   
   - parameter state:  the current state
   - parameter action: the action that has been dispatched
   - returns: the new state
  */
  static func reduce(state: State, action: Self) -> State
}

public extension Action {
  /**
   Implementation of the AnyAction protocol.
   
   - seeAlso: `AnyAction`
  */
  static func anyReduce(state: State, action: AnyAction) -> State {
    guard let action = action as? Self else {
      preconditionFailure("Action reducer invoked with a wrong 'action' parameter")
    }
    
    return self.reduce(state: state, action: action)
  }
}
