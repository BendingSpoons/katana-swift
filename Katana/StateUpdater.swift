//
//  StateUpdater.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public protocol AnyStateUpdater: Dispatchable {
  func updateState(currentState: State) -> State
}

public protocol StateUpdater: AnyStateUpdater {
  associatedtype StateType: State
  
  func updatedState(_ state: inout StateType)
}

public extension StateUpdater {
  func updateState(currentState: State) -> State {
    guard var typedState = currentState as? StateType else {
      fatalError("[Katana] updateState invoked with the wrong state type")
    }
    
    self.updatedState(&typedState)
    return typedState
  }
}
