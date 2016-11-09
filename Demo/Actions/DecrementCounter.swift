//
//  DecrementCounter.swift
//  Katana
//
//  Created by Andrea De Angelis on 08/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct DecrementCounter: Action {
  static func updatedState(currentState: State, action: DecrementCounter) -> State {
    guard var state = currentState as? CounterState else { fatalError("wrong state type") }
    state.counter -= 1
    return state
  }
}
