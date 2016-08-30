//
//  SmartReducer.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct SyncAsyncReducer<ReducerState: State> : Reducer {
  public static func reduce(action: Action, state: ReducerState) -> ReducerState {
    
    if let action = action as? AnySyncAction {
      let result = type(of: action).anyReduce(state: state, action: action) as! ReducerState
      return result
    }
    
    
    if let action = action as? AnyAsyncAction {
      let result = type(of: action).anyReduce(state: state, action: action) as! ReducerState
      return result
    }
    
    fatalError("SmartReducer can only reduce Asny/Sync Actions")
  }
}
