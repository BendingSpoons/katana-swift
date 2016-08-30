//
//  Saga.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public func sagaMiddleware<R: Reducer>(reducer _: R.Type) -> StoreMiddleware<R> {
  return { store in
    return { next in
      return { action in
        
        if let action = action as? AnySyncAction {
          type(of: action).anySaga(action: action, state: store.getState(), dispatch: store.dispatch)
        
        } else if let action = action as? AnyAsyncAction {
          if action.state == .loading {
            type(of: action).anySaga(action: action, state: store.getState(), dispatch: store.dispatch)
          }
          
        } else {
          fatalError("SagaMiddleware can handle only Asny/Sync Actions")
        }
        
        next(action)
      }
    }
  }
}
