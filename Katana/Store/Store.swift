//
//  Store.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// Type Erasure for `Store`
public protocol AnyStore: class {
  /// Type Erasure for the `Store` `state`
  var anyState: State { get }

  /**
   Dispatches an action
   
   - parameter action: the action to dispatch
  */
  func dispatch(_ action: Action)

  /**
   Adds a listener to the store. A listener is basically a closure that is invoked
   every time the Store's state changes
   
   - parameter listener: the listener closure
   - returns: a closure that can be used to remove the listener
  */
  func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe
}

/**
 The `Store` class contains and manages the state of the application and the
 updates to the state itself.
 
 In Katana, every relevant information in the application should be stored in the
 Store's state. The only way to update the state is to dispatch an `Action`. At this point
 the store will execute the following operations:
 
 - it executes the middleware
 - it creates the new state, by invoking the `updateState` function of the action
 - it updates the state
 - it executes the side effect of the action, if implemented (see `ActionWithSideEffect`)
 - it invokes all the listeners
 
 #### UI Integration
 You typically don't deal directly with the store in the UI.
 Katana will update the UI automatically when the state changes. It will also allow you to
 get pieces of information from the store's state when you need them.
 See `ConnectedNodeDescription` for more information about this topic
*/
open class Store<StateType: State> {

  /// The current state of the application
  open fileprivate(set) var state: StateType

  /// The  array of registered listeners
  fileprivate var listeners: [StoreListener]

  /// The array of middleware of the store
  fileprivate let middleware: [StoreMiddleware]

  /**
   The dependencies used in the actions side effects
   
   - seeAlso: `ActionWithSideEffect`
  */
  fileprivate var dependencies: SideEffectDependencyContainer!

  /**
    The internal dispatch function. It combines all the operations that should be done when an action is dispatched.
    The variable is explicitly unwrapped because of the init method
  */
  fileprivate var dispatchFunction: StoreDispatch!

  /// The queue in witch actions are managed
  lazy private var dispatchQueue: DispatchQueue = {
    // serial by default
    return DispatchQueue(label: "katana.store.queue")
  }()

  /**
   A convenience init method. The store won't have middleware nor dependencies for the actions
   side effects
   
   - returns: An instance of store
  */
  convenience public init() {
    self.init(middleware: [], dependencies: EmptySideEffectDependencyContainer.self)
  }

  /**
   The default init method for the Store.
   
   - parameter middleware:   the middleware to trigger when an action is dispatched
   - parameter dependencies:  the dependencies to use in the actions side effects
   - returns: An instance of store configured with the given properties
  */
  public init(middleware: [StoreMiddleware], dependencies: SideEffectDependencyContainer.Type) {
    self.listeners = []
    self.state = StateType()
    self.middleware = middleware
    // create the dispatch function

    let getState = { [unowned self] () -> StateType in
      return self.state
    }
    
    let m = self.middleware.map { middleware in
      middleware(getState, self.dispatch)
    }
    
    self.dispatchFunction = self.composeMiddlewares(m, with: self.performDispatch)
    self.dependencies = dependencies.init(dispatch: self.dispatch)
  }

  /**
   Adds a listener to the store. A listener is basically a closure that is invoked
   every time the Store's state changes. The listener is always invoked in the main queue
   
   - parameter listener: the listener closure
   - returns: a closure that can be used to remove the listener
  */
  public func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe {
    self.listeners.append(listener)
    let idx = listeners.count - 1

    return { [weak self] in
      _ = self?.listeners.remove(at: idx)
    }
  }

  /**
   Dispatches an action
   
   - parameter action: the action to dispatch
  */
  public func dispatch(_ action: Action) {
    self.dispatchQueue.async {
      self.dispatchFunction(action)
    }
    
  }
}

fileprivate extension Store {
  /// Type used internally to store partially applied middleware
  fileprivate typealias PartiallyAppliedMiddleware = (_ next: @escaping StoreDispatch) -> (_ action: Action) -> ()

  /**
   This function composes the middleware with the store dispatch
   
   - parameter middleware:   the middleware to use
   - parameter storeDispatch: the store dispatch function
   - returns: a function that invokes all the middleware and then the store dispatch function
  */
  fileprivate func composeMiddlewares(_ middleware: [PartiallyAppliedMiddleware],
                           with storeDispatch: @escaping StoreDispatch) -> StoreDispatch {

    guard !middleware.isEmpty else {
      return storeDispatch
    }
  
    guard middleware.count > 1 else {
      return middleware.first!(storeDispatch)
    }
  
    var m = middleware
    let last = m.removeLast()

    return m.reduce(last(storeDispatch), { chain, middleware in
      return middleware(chain)
    })
  }

  /**
   Calculates the new state based on the current state and the given action.
   This method also invokes all the listeners
   
   - parameter action: the action that has been dispatched
  */
  fileprivate func performDispatch(_ action: Action) {
    let newState = action.updatedState(currentState: self.state)

    guard let typedNewState = newState as? StateType else {
      preconditionFailure("Action updateState returned a wrong state type")
    }

    let previousState = self.state
    self.state = typedNewState

    // executes the side effects, if needed
    self.triggerSideEffect(for: action, previousState: previousState, currentState: typedNewState)
    
    // listener are always invoked in the main queue
    DispatchQueue.main.async {
      self.listeners.forEach { $0() }
    }
  }

  /**
    Executes the side effect, if available
   
    - parameter action: the dispatched action
    - parameter previousState: the previous state
    - parameter currentState: the current state
  */
  fileprivate func triggerSideEffect(for action: Action, previousState: StateType, currentState: StateType) {
    guard let action = action as? ActionWithSideEffect else {
      return
    }
    
    if let async = action as? AnyAsyncAction, async.state != .loading {
      return
    }

    action.sideEffect(
      currentState: currentState,
      previousState: previousState,
      dispatch: self.dispatch,
      dependencies: self.dependencies
    )
  }
}

extension Store: AnyStore {
  /**
   Implementation of the AnyStore protocol.
   
   - seeAlso: `AnyStore`
  */
  public var anyState: State {
    return self.state
  }
}
