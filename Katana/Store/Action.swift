//
//  File.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public protocol AnyAction {
  static func anyReduce(state: State, action: AnyAction) -> State
}

public protocol Action: AnyAction {
  static func reduce(state: State, action: Self) -> State
}

public extension Action {
  static func anyReduce(state: State, action: AnyAction) -> State {
    guard let action = action as? Self else {
      preconditionFailure("Action reducer invoked with a wrong 'action' parameter")
    }
    
    return self.reduce(state: state, action: action)
  }
}
