//
//  AsyncReducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 11/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

protocol AsyncReducer: Reducer {
  associatedtype Payload
  associatedtype CompletedPayload
  associatedtype ErrorPayload
  associatedtype StateType: State
  
  static func reduceLoading(action: AsyncAction<Payload, CompletedPayload, ErrorPayload>, state: StateType) -> StateType
  static func reduceCompleted(action: AsyncAction<Payload, CompletedPayload, ErrorPayload>, state: StateType) -> StateType
  static func reduceError(action: AsyncAction<Payload, CompletedPayload, ErrorPayload>, state: StateType) -> StateType
}

extension AsyncReducer {
  static func reduce(action: Action, state: StateType?) -> StateType {
    guard let s = state else {
      preconditionFailure("This should not happen. \(Self.self) is meant to be used in a ReducerCombiner. If you already doing this, it may be that there is a bug in the library implementation. Please open an issue on github")
    }
    
    guard let a = action as? AsyncAction<Payload, CompletedPayload, ErrorPayload> else {
      preconditionFailure("This should not happen. \(Self.self) is meant to be used with a \(AsyncAction<Payload, CompletedPayload, ErrorPayload>.self) action. Check the reducer combiner and make sure that you are associating this reducer with the proper action. If you already doing this, it may be that there is a bug in the library implementation. Please open an issue on github")
    }
    
    
    switch a.state {
    case .Loading:
      return self.reduceLoading(action: a, state: s)
      
    case .Completed:
      return self.reduceCompleted(action: a, state: s)
      
    case .Error:
      return self.reduceError(action: a, state: s)
    }
  }
}
