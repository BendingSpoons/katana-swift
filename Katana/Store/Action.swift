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
   
   - seeAlso: `Action`, `updateState(currentState:action:)` method
  */
  static func anyUpdatedState(currentState: State, action: AnyAction) -> State
}

/**
 An action represents an event that leads to a change in the state of the application.
 It can be triggered from an user action, from a system event or any event in general.
 
 In general this protocol should not be used directly. Use `SyncAction` and `AsyncAction` instead
*/
public protocol Action: AnyAction {
  /**
   Creates the new state starting from the current state and the action. It is important
   to note that `updateState(currentState:action:)` should be a 
   [pure function](https://en.wikipedia.org/wiki/Pure_function), that is
   a function that given the same input always returns the same output and it also
   doesn't have any side effect. This is really important because it is an assumption
   that Katana (an related tools) make in order to implement some functionalities
   (e.g., not implemented yet, but possible in the future: time travel)
   
   - parameter state:  the current state
   - parameter action: the action that has been dispatched
   - returns: the new state
  */
  static func updatedState(currentState: State, action: Self) -> State
}

public extension Action {
  /**
   Implementation of the AnyAction protocol.
   
   - seeAlso: `AnyAction`
  */
  static func anyUpdatedState(currentState: State, action: AnyAction) -> State {
    guard let action = action as? Self else {
      preconditionFailure("updateState invoked with a wrong 'action' parameter")
    }
    
    return self.updatedState(currentState: currentState, action: action)
  }
}
