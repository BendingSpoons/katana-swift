//
//  Actions.swift
//  Demo
//
//  Created by Mauro Bolis on 19/02/2018.
//

import Foundation
import Katana

struct IncrementCounter: Action {
  func updatedState(currentState: State) -> State {
    guard var state = currentState as? AppState else {
      return currentState
    }

    state.counter += 1
    return state
  }
}

struct DecrementCounter: Action {
  func updatedState(currentState: State) -> State {
    guard var state = currentState as? AppState else {
      return currentState
    }
    
    state.counter -= 1
    return state
  }
}

struct SetCounter: Action {
  let value: Int
  
  func updatedState(currentState: State) -> State {
    guard var state = currentState as? AppState else {
      return currentState
    }
    
    state.counter = value
    return state
  }
  
  var debugDescription: String {
    return "\(String(reflecting: type(of: self))) to \(self.value)"
  }
}
