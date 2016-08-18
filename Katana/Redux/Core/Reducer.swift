//
//  Reducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public protocol AnyReducer {
  static func _reduce(action: Action, state: State?) -> State
}

public protocol Reducer: AnyReducer {
  associatedtype StateType: State
  static func reduce(action: Action, state: StateType?) -> StateType
}

public extension Reducer {
  static func _reduce(action: Action, state: State?) -> State {
    guard let state = state else {
      return self.reduce(action: action, state: nil)
    }
    
    guard let specificState = state as? StateType else {
      return state
    }
    
    return self.reduce(action: action, state: specificState)
  }
}
