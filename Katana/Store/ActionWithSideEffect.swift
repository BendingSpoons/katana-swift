//
//  SideEffectable.swift
//  Katana
//
//  Created by Mauro Bolis on 29/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyActionWithSideEffect: AnyAction {
  static func anySideEffect(
    action: AnyAction,
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  )
}

public protocol ActionWithSideEffect: Action, AnyActionWithSideEffect {
  static func sideEffect(
    action: Self,
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  )
}

public extension ActionWithSideEffect {
  static func anySideEffect(
    action: AnyAction,
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  ) {
   
    guard let action = action as? Self else {
      preconditionFailure("Action side effect invoked with a wrong 'action' parameter")
    }
    
    self.sideEffect(action: action, state: state, dispatch: dispatch, dependencies: dependencies)
  }
}
