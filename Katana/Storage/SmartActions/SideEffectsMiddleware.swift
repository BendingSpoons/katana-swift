//
//  Saga.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public func sideEffectsMiddleware<S: State>(state _: S.Type) -> StoreMiddleware<S> {
  return { state, dispatch in
    return { next in
      return { action in
        
        if let action = action as? AnySmartActionWithSideEffect {
          type(of: action).anySideEffect(action: action, state: state, dispatch: dispatch)
        }

        next(action)
      }
    }
  }
}
