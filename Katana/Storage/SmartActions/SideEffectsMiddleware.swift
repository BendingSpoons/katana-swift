//
//  Saga.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation


open class SideEffectsDependenciesContainer<S: State> {
  let state: S
  let dispatch: StoreDispatch
  
  required public init(dispatch: StoreDispatch, state: S) {
    self.state = state
    self.dispatch = dispatch
  }
}


public func sideEffectsMiddleware<S: State>(state _: S.Type,
                                  dependencies: SideEffectsDependenciesContainer<S>.Type?) -> StoreMiddleware<S> {
  
  return { state, dispatch in
    return { next in
      return { action in
        
        if let action = action as? AnySmartActionWithSideEffect {
          
          let dependencies = dependencies?.init(dispatch: dispatch, state: state)
          
          
          type(of: action).anySideEffect(action: action, state: state, dispatch: dispatch, dependencies: dependencies)
        }

        next(action)
      }
    }
  }
}
