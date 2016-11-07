//
//  SideEffectable.swift
//  Katana
//
//  Created by Mauro Bolis on 29/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/// Type Erasure for `ActionWithSideEffect`
public protocol AnyActionWithSideEffect: AnyAction {
  /**
   Performs a side effect for the action
   
   - seeAlso: `ActionWithSideEffect`, `sideEffect(action:state:dispatch:dependencies:)`
  */
  static func anySideEffect(
    action: AnyAction,
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  )
}

/**
 `Action` can implement this protocol to perform side effects when an instance is
 dispatched.
 
 A side effect is nothing more than a piece of code that can interact with external
 services or APIs (e.g., make a network request, get information from the disk and so on).
 Side effects are needed because the `updateState(currentState:action:)` function (which is the only other operation
 that is performed when an action is dispatched) must be pure and therefore it cannot
 interact with disk, network and so on.
 
 ### Dependencies
 You can see from the `sideEffect(action:state:dispatch:dependencies:)` signature that
 a side effect takes as input some dependencies. This is a form of dependency injection
 for the side effects. By using only methods coming from the dependencies (instead of relying on
 global imports), testing is much more easier since you can inject a mocked version
 of the things you need in the side effect. For example, in a test, you may want to
 inject a mocked version of the class that manages the API requests, in order to control
 the result of the network call.
 
 Every time a side effect is triggered, the dependencies (or better, the `SideEffectDependencyContainer`)
 is instantiated from scratch. We do this to avoid that pieces of state are saved in the managers or
 in the classes that there are in the dependencies, since we want to store all the relevant
 information in the `Store`
*/
public protocol ActionWithSideEffect: Action, AnyActionWithSideEffect {
  /**
   Performs the side effect. This method is invoked when the action is dispatched,
   before it goes in the `updateState(currentState:action:)` function.
   
   - parameter action:        the dispatched action
   - parameter state:         the current state
   - parameter dispatch:      a closure that can be used to dispatch new actions
   - parameter dependencies:  the dependencies of the side effect
  */
  static func sideEffect(
    action: Self,
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  )
}

public extension ActionWithSideEffect {
  /**
   Default implementation of `anySideEffect`.
   It invokes `sideEffect(action:state:dispatch:dependencies:)` by casting the parameters
   to the proper types.
   
   - seeAlso: `AnyActionWithSideEffect`
  */
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
