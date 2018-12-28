//
//  StateUpdater.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// Type erasure for `StateUpdater`
public protocol AnyStateUpdater: Dispatchable {
  /**
   Creates the new state starting from the current state. It is important
   to note that `updateState(currentState:)` should be a
   [pure function](https://en.wikipedia.org/wiki/Pure_function), that is
   a function that given the same input always returns the same output and it also
   doesn't have any side effect. This is really important because it is an assumption
   that Katana (and related tools) makes in order to implement some functionalities.
   
   - parameter currentState: the current configuration of the state
   - returns: the new versin of the state
  */
  func updatedState(currentState: State) -> State
}

/**
 A `StateUpdater` is a `Dispatchable` that can be used to update the `Store`
 state configuration.
 
 The `StateUpdater` is strongly tied to the state that it handles. This greatily simplifies
 the code written in normal situations. However, if you need to create updaters that are not strictly
 tied to a concrete state type (e.g., in a library) you can use `AnyStateUpdater`.
*/
public protocol StateUpdater: AnyStateUpdater {
  /// The concrete state type that the updater manages
  associatedtype StateType: State
  
  /**
   Updates the current state. It is important to note that `updateState(currentState:)`
   should be a [pure function](https://en.wikipedia.org/wiki/Pure_function), that is
   a function that given the same input always returns the same output and it also
   doesn't have any side effect. This is really important because it is an assumption
   that Katana (and related tools) makes in order to implement some functionalities.
   
   - parameter state: the current configuration of the state. The method is meant to update
   the value of the state in place
  */
  func updateState(_ state: inout StateType)
}

/// Conformance of `StateUpdater` to `AnyStateUpdater`
public extension StateUpdater {
  func updatedState(currentState: State) -> State {
    guard var typedState = currentState as? StateType else {
      fatalError("[Katana] updateState invoked with the wrong state type")
    }
    
    self.updateState(&typedState)
    return typedState
  }
}
