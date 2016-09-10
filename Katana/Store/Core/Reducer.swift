//
//  Reducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public protocol AnyReducer {
  static func anyReduce(action: Action, state: State) -> State
}

public protocol Reducer: AnyReducer {
  associatedtype StateType: State
  static func reduce(action: Action, state: StateType) -> StateType
}

public extension AnyReducer where Self: Reducer {
  
  static func anyReduce(action: Action, state: State) -> State {
    guard let typedState = state as? StateType else {
      return state
    }
    
    return self.reduce(action: action, state: typedState)
  }
}
