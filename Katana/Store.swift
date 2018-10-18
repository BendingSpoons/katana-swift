//
//  Store.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

///// Type Erasure for `Store`
//public protocol AnyStore: class {
//  /// Type Erasure for the `Store` `state`
//  var anyState: State { get }
//
//  /**
//   Dispatches an action
//   
//   - parameter action: the action to dispatch
//  */
//  func dispatch(_ action: Action)
//
//  /**
//   Adds a listener to the store. A listener is basically a closure that is invoked
//   every time the Store's state changes
//   
//   - parameter listener: the listener closure
//   - returns: a closure that can be used to remove the listener
//  */
//  func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe
//}
//
///**
// The `Store` class contains and manages the state of the application and the
// updates to the state itself.
// 
// In Katana, every relevant information in the application should be stored in the
// Store's state. The only way to update the state is to dispatch an `Action`. At this point
// the store will execute the following operations:
// 
// - it executes the middleware
// - it creates the new state, by invoking the `updateState` function of the action
// - it updates the state
// - it executes the side effect of the action, if implemented (see `ActionWithSideEffect`)
// - it invokes all the listeners
// 
// #### UI Integration
// You typically don't deal directly with the store in the UI.
// Katana will update the UI automatically when the state changes. It will also allow you to
// get pieces of information from the store's state when you need them.
// See `ConnectedNodeDescription` for more information about this topic
//*/
//open class Store<StateType: State> {
//  
//  /// Creates an empty state
//  private static func emptyStateInitializer() -> StateType {
//    return StateType()
//  }
//  
//  typealias ListenerID = String
//  
//  /// Closure that is used to initialize the state
//  public typealias StateInitializer<T: State> = () -> T
//
//  /// The current state of the application
//  open fileprivate(set) var state: StateType
//
//  /// The  array of registered listeners
//  fileprivate var listeners: [ListenerID: StoreListener]
//
//  /// The array of middleware of the store
//  fileprivate let middleware: [StoreMiddleware]
//
//  /// Whether the store is ready to execute operations
//  public var isReady: Bool { return self.actionsQueue.isSuspended }
//  
//  /**
//   The dependencies used in the actions side effects
//   
//   - seeAlso: `ActionWithSideEffect`
//  */
//  public var dependencies: SideEffectDependencyContainer!
//
//  /**
//    The internal dispatch function. It combines all the operations that should be done when an action is dispatched
//  */
//  fileprivate var dispatchFunction: StoreDispatch?
//
//  /// The queue in which actions are managed
//  lazy fileprivate var actionsQueue: OperationQueue = {
//    let operation = OperationQueue()
//    operation.maxConcurrentOperationCount = 1
//    operation.qualityOfService = .userInitiated
//    
//    // queue is initially supended. The store will enable the queue when
//    // all the setup is done.
//    // we basically enqueue all the dispatched actions until
//    // everything is needed to manage them is correctly sat up
//    operation.isSuspended = true
//    
//    return operation
//  }()
//
//  /**
//   A convenience init method. The store won't have middleware nor dependencies for the actions
//   side effects. The state will be created using the default init of the state
//   
//   - returns: An instance of store
//  */
//  convenience public init() {
//    self.init(
//      middleware: [],
//      dependencies: EmptySideEffectDependencyContainer.self,
//      stateInitializer: Store<StateType>.emptyStateInitializer
//    )
//  }
//
//  /**
//   A convenience init method for the Store. The initial state will be created using the default
//   init of the state type.
//   
//   - parameter middleware:   the middleware to trigger when an action is dispatched
//   - parameter dependencies:  the dependencies to use in the actions side effects
//   - returns: An instance of store configured with the given properties
//   */
//  convenience public init(middleware: [StoreMiddleware], dependencies: SideEffectDependencyContainer.Type) {
//    self.init(
//      middleware: middleware,
//      dependencies: dependencies,
//      stateInitializer: Store<StateType>.emptyStateInitializer
//    )
//  }
//  
//  /**
//   The default init method for the Store.
//   
//   - parameter middleware:   the middleware to trigger when an action is dispatched
//   - parameter dependencies:  the dependencies to use in the actions side effects
//   - parameter stateInitializer:  a closure invoked to define the first state's value
//   - returns: An instance of store configured with the given properties
//  */
//  public init(middleware: [StoreMiddleware], dependencies: SideEffectDependencyContainer.Type, stateInitializer: @escaping StateInitializer<StateType>) {
//    self.listeners = [:]
//    self.middleware = middleware
//    self.state = Store<StateType>.emptyStateInitializer()
//    self.dependencies = dependencies.init(dispatch: self.dispatch, getState: self.getState)
//    
//    /// Do the initialization operation async to avoid to block the store init caller
//    /// which in a standard application is the AppDelegate. WatchDog may decide to kill the app
//    /// if the stateInitializer function takes too much to do its job and we block the app's startup
//    DispatchQueue.main.async {
//      self.initializeInternalState(using: stateInitializer)
//    }
//  }
//  
//  /// Creates and initializes the internal values.
//  /// Store doesn't start to work (that is, actions are not dispatched) till this function is executed
//  private func initializeInternalState(using stateInizializer: StateInitializer<StateType>) {
//    self.state = stateInizializer()
//    
//    let initializedMiddleware = self.middleware.map { middleware in
//      return middleware(self.getState, self.dispatch)
//    }
//    
//    // chain the middleware with the final step, which is the reduction of the state and the side effects management
//    self.dispatchFunction = Store.composeMiddlewares(initializedMiddleware, with: self.manageAction)
//    
//    // and here we are finally able to start the actions management
//    self.actionsQueue.isSuspended = false
//  }
//  
//  private func getState() -> StateType {
//    //swiftlint:disable line_length
//    assert(!self.actionsQueue.isSuspended, "The state is not ready yet. You should wait until the state is ready to invoke getState. If you are performing operations in the dependenciesContainer's init, then the suggested way to approach this is to dispatch an action. This will guarantee that the actions are dispatched correctly")
//    //swiftlint:enable line_length
//
//    return self.state
//  }
//
//  /**
//   Adds a listener to the store. A listener is basically a closure that is invoked
//   every time the Store's state changes. The listener is always invoked in the main queue
//   
//   - parameter listener: the listener closure
//   - returns: a closure that can be used to remove the listener
//  */
//  public func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe {
//    let listenerID: ListenerID = UUID().uuidString
//    self.listeners[listenerID] = listener
//
//    return { [weak self] in
//      _ = self?.listeners.removeValue(forKey: listenerID)
//    }
//  }
//
//  /**
//   Dispatches an action
//   
//   - parameter action: the action to dispatch
//  */
//  public func dispatch(_ action: Action) {
//    
//    // the dispatch function simply puts the action in the queue
//    self.actionsQueue.addOperation { [unowned self] in
//      guard let function = self.dispatchFunction else {
//        fatalError("Something is wrong, the action queue has been started before the initialization has been completed")
//      }
//      
//      function(action)
//    }
//  }
//}
//
//fileprivate extension Store {
//  /// Type used internally to store partially applied middleware
//  fileprivate typealias PartiallyAppliedMiddleware = (_ next: @escaping StoreDispatch) -> (_ action: Action) -> ()
//
//  /**
//   Calculates the new state based on the current state and the given action.
//   This method also invokes all the listeners in the main queue
//   
//   - parameter action: the action that has been dispatched
//  */
//  fileprivate func manageAction(_ action: Action) {
//    let newState = action.updatedState(currentState: self.state)
//
//    guard let typedNewState = newState as? StateType else {
//      preconditionFailure("Action updatedState returned a wrong state type")
//    }
//
//    let previousState = self.state
//    self.state = typedNewState
//
//    // executes the side effects, if needed
//    self.triggerSideEffect(for: action, previousState: previousState, currentState: typedNewState)
//    
//    // listener are always invoked in the main queue
//    DispatchQueue.main.async {
//      self.listeners.values.forEach { $0() }
//    }
//  }
//
//  /**
//    Executes the side effect, if available
//   
//    - parameter action: the dispatched action
//    - parameter previousState: the previous state
//    - parameter currentState: the current state
//  */
//  fileprivate func triggerSideEffect(for action: Action, previousState: StateType, currentState: StateType) {
//    guard let action = action as? ActionWithSideEffect else {
//      return
//    }
//    
//    if let async = action as? AnyAsyncAction, async.state != .loading {
//      return
//    }
//
//    action.sideEffect(
//      currentState: currentState,
//      previousState: previousState,
//      dispatch: self.dispatch,
//      dependencies: self.dependencies
//    )
//  }
//}
//
//// MARK: Utilities
//fileprivate extension Store {
//  
//  /**
//   This function composes the middleware with the store dispatch
//   
//   - parameter middleware:   the middleware to use
//   - parameter storeDispatch: the store dispatch function
//   - returns: a function that invokes all the middleware and then the store dispatch function
//   */
//  fileprivate static func composeMiddlewares(
//    _ middleware: [PartiallyAppliedMiddleware],
//    with storeDispatch: @escaping StoreDispatch) -> StoreDispatch {
//    
//    guard !middleware.isEmpty else {
//      return storeDispatch
//    }
//    
//    guard middleware.count > 1 else {
//      return middleware.first!(storeDispatch)
//    }
//    
//    var m = middleware
//    let last = m.removeLast()
//    
//    return m.reduce(last(storeDispatch), { chain, middleware in
//      return middleware(chain)
//    })
//  }
//}
//
//extension Store: AnyStore {
//  /**
//   Implementation of the AnyStore protocol.
//   
//   - seeAlso: `AnyStore`
//  */
//  public var anyState: State {
//    return self.state
//  }
//}
