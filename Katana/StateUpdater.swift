//
//  StateUpdater.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public protocol AnyStateUpdater: Dispatchable {
  func updatedState(currentState: State) -> State
}

public protocol StateUpdater: AnyStateUpdater {
  associatedtype StateType: State
  
  func updateState(_ state: inout StateType)
}

public extension StateUpdater {
  func updatedState(currentState: State) -> State {
    guard var typedState = currentState as? StateType else {
      fatalError("[Katana] updateState invoked with the wrong state type")
    }
    
    self.updateState(&typedState)
    return typedState
  }
}
