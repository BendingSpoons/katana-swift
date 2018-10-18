//
//  Action.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 An action represents an event that leads to a change in the state of the application.
 It can be triggered from a user action, from a system event or any event in general.
 
 In general this protocol should not be used directly.
*/
public protocol Action: CustomDebugStringConvertible {
  /**
   Creates the new state starting from the current state and the action. It is important
   to note that `updateState(currentState:action:)` should be a 
   [pure function](https://en.wikipedia.org/wiki/Pure_function), that is
   a function that given the same input always returns the same output and it also
   doesn't have any side effect. This is really important because it is an assumption
   that Katana (and related tools) makes in order to implement some functionalities
   (e.g., not implemented yet, but possible in the future: time travel)
   
   - parameter state:  the current state
   - parameter action: the action that has been dispatched
   - returns: the new state
  */
  func updatedState(currentState: State) -> State
}

/// Implementation of the `CustomDebugStringConvertible` protocol
extension Action {
  public var debugDescription: String {
    return String(reflecting: type(of: self))
  }
}
