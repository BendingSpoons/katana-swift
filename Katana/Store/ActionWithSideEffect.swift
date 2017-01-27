//
//  SideEffectable.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 `Action` can implement this protocol to perform side effects when an instance is
 dispatched.
 
 A side effect is nothing more than a piece of code that can interact with external
 services or APIs (e.g., make a network request, get information from the disk and so on).
 Side effects are needed because the `updateState(currentState:)` function (which is the only other operation
 that is performed when an action is dispatched) must be pure and therefore it cannot
 interact with disk, network and so on.
 
 ### Dependencies
 You can see from the `sideEffect(state:dispatch:dependencies:)` signature that
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
public protocol ActionWithSideEffect: Action {
  /**
   Performs the side effect. This method is invoked when the action is dispatched,
   before it goes in the `updateState(currentState:action:)` function.
   
   - parameter state:         the current state
   - parameter dispatch:      a closure that can be used to dispatch new actions
   - parameter dependencies:  the dependencies of the side effect
  */
  func sideEffect(
    state: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer
  )
}
