//
//  StateUpdater.swift
//  Katana
//
//  Created by Mauro Bolis on 18/10/2018.
//

import Foundation

public protocol AnyStateUpdater {
  func updateState(currentState: State) -> State
}

public protocol StateUpdater {
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
