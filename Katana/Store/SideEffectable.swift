//
//  SideEffectable.swift
//  Katana
//
//  Created by Mauro Bolis on 29/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnySideEffectable: AnyAction {
  static func anySideEffect(
    action: AnyAction,
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  )
}

public protocol SideEffectable: Action, AnySideEffectable {
  static func sideEffect(
    action: Self,
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  )
}

public extension SideEffectable {
  static func anySideEffect(
    action: AnyAction,
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  ) {
   
    guard let a = action as? Self else {
      preconditionFailure("Action side effect invoked with a wrong 'action' parameter")
    }
    
    self.sideEffect(action: a, state: state, dispatch: dispatch, dependencies: dependencies)
  }
}
