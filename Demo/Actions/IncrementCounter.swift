//
//  IncrementCounter.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct IncrementCounter: Action {
  static func updatedState(currentState: State, action: IncrementCounter) -> State {
    guard var state = currentState as? CounterState else { fatalError("wrong state type") }
    state.counter += 1
    return state
  }
}
