//
//  SyncReducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 11/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public protocol SyncReducer: Reducer {
  associatedtype Payload
  associatedtype StateType: State
  static func reduceSync(action: SyncAction<Payload>, state: StateType) -> StateType
}

public extension SyncReducer {
  static func reduce(action: Action, state: StateType?) -> StateType {
    guard let s = state else {
      fatalError("This should not happen. \(Self.self) is meant to be used in a ReducerCombiner. If you already doing this, it may be that there is a bug in the library implementation. Please open an issue on github")
    }
    
    guard let a = action as? SyncAction<Payload> else {
      fatalError("This should not happen. \(Self.self) is meant to be used with a \(SyncAction<Payload>.self) action. Check the reducer combiner and make sure that you are associating this reducer with the proper action. If you already doing this, it may be that there is a bug in the library implementation. Please open an issue on github")
    }
    
    return self.reduceSync(action: a, state: s)
  }
}
