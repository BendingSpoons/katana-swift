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
  
  @discardableResult
  func dispatch(_ updater: Dispatchable) -> Promise<Void>
  
  /**
   Adds a listener to the store. A listener is basically a closure that is invoked
   every time the Store's state changes
   
   - parameter listener: the listener closure
   - returns: a closure that can be used to remove the listener
   */
  func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe
}

open class PartialStore<S: State>: AnyStore {
  /// The current state of the application
  open fileprivate(set) var state: S
  
  /**
   Implementation of the AnyStore protocol.
   
   - seeAlso: `AnyStore`
   */
  public var anyState: State {
    return self.state
  }
  
  fileprivate init(state: S) {
    self.state = state
  }
  
  @discardableResult
  public func dispatch(_ dispatchable: Dispatchable) -> Promise<Void> {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }
  
  public func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }
}

/// Creates an empty state
private func emptyStateInitializer<S: State>() -> S {
  return S()
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
open class Store<S: State, D: SideEffectDependencyContainer>: PartialStore<S> {
  typealias ListenerID = String
  
  /// Closure that is used to initialize the state
  public typealias StateInitializer<T: State> = () -> T
  
  /// The  array of registered listeners
  fileprivate var listeners: [ListenerID: StoreListener]
  
  /// The array of middleware of the store
  fileprivate let interceptors: [StoreInterceptor]
  
  fileprivate var initializedInterceptors: [InitializedInterceptor]!
  
  /// Whether the store is ready to execute operations
  public private(set) var isReady: Bool
  
  /**
   The dependencies used in the actions side effects
   
   - seeAlso: `ActionWithSideEffect`
   */
  public var dependencies: D!
  
  private var sideEffectContext: SideEffectContext<S, D>!
  
  lazy fileprivate var stateUpdaterQueue: DispatchQueue = {
    let d = DispatchQueue(label: "katana.stateupdater", qos: .userInteractive)
    
    // queue is initially supended. The store will enable the queue when
    // all the setup is done.
    // we basically enqueue all the dispatched actions until
    // everything is needed to manage them is correctly sat up
    d.suspend()
    
    return d
  }()
  
  lazy fileprivate var sideEffectQueue: DispatchQueue = {
    let d = DispatchQueue(label: "katana.sideEffect", qos: .userInteractive, attributes: .concurrent)
    
    // queue is initially supended. The store will enable the queue when
    // all the setup is done.
    // we basically enqueue all the dispatched actions until
    // everything is needed to manage them is correctly sat up
    d.suspend()
    
    return d
  }()
  
  /**
   A convenience init method. The store won't have middleware nor dependencies for the actions
   side effects. The state will be created using the default init of the state
   
   - returns: An instance of store
   */
  convenience public init() {
    self.init(interceptors: [], stateInitializer: emptyStateInitializer)
  }
  
  /**
   A convenience init method for the Store. The initial state will be created using the default
   init of the state type.
   
   - parameter middleware:   the middleware to trigger when an action is dispatched
   - parameter dependencies:  the dependencies to use in the actions side effects
   - returns: An instance of store configured with the given properties
   */
  convenience public init(interceptors: [StoreInterceptor]) {
    self.init(
      interceptors: interceptors,
      stateInitializer: emptyStateInitializer
    )
  }
  
  /**
   The default init method for the Store.
   
   - parameter middleware:   the middleware to trigger when an action is dispatched
   - parameter dependencies:  the dependencies to use in the actions side effects
   - parameter stateInitializer:  a closure invoked to define the first state's value
   - returns: An instance of store configured with the given properties
   */
  public init(interceptors: [StoreInterceptor], stateInitializer: @escaping StateInitializer<S>) {
    self.listeners = [:]
    self.interceptors = interceptors
    self.isReady = false
    
    let emptyState: S = emptyStateInitializer()
    super.init(state: emptyState)
    
    self.dependencies = D.init(dispatch: self.dispatch, getState: self.getState)
    
    self.sideEffectContext = SideEffectContext<S, D>(
      dependencies: self.dependencies,
      getState: self.getState,
      dispatch: self.dispatch
    )
    
    /// Do the initialization operation async to avoid to block the store init caller
    /// which in a standard application is the AppDelegate. WatchDog may decide to kill the app
    /// if the stateInitializer function takes too much to do its job and we block the app's startup
    DispatchQueue.main.async {
      self.initializeInternalState(using: stateInitializer)
    }
  }
  
  /**
   Adds a listener to the store. A listener is basically a closure that is invoked
   every time the Store's state changes. The listener is always invoked in the main queue
   
   - parameter listener: the listener closure
   - returns: a closure that can be used to remove the listener
   */
  override public func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe {
    let listenerID: ListenerID = UUID().uuidString
    self.listeners[listenerID] = listener
    
    return { [weak self] in
      _ = self?.listeners.removeValue(forKey: listenerID)
    }
  }
  
  @discardableResult
  override public func dispatch(_ dispatchable: Dispatchable) -> Promise<Void> {
    if let _ = dispatchable as? AnyStateUpdater & AnySideEffect {
      fatalError("The parameter cannot implement both the state updater and the side effect")
    }
    
    if let stateUpdater = dispatchable as? AnyStateUpdater {
      return self.enqueueStateUpdater(stateUpdater)
      
    } else if let sideEffect = dispatchable as? AnySideEffect {
      return self.enqueueSideEffect(sideEffect)
      
    } else if let action = dispatchable as? Action {
      return self.enqueueAction(action)
    }
    
    fatalError("Invalid parameter")
  }
  
  fileprivate func nonPromisableDispatch(_ dispatchable: Dispatchable) {
    self.dispatch(dispatchable)
  }
}

// MARK: Private utilities
private extension Store {
  /// Creates and initializes the internal values.
  /// Store doesn't start to work (that is, actions are not dispatched) till this function is executed
  private func initializeInternalState(using stateInizializer: StateInitializer<S>) {
    self.state = stateInizializer()
    self.initializedInterceptors = Store.initializedInterceptors(self.interceptors, sideEffectContext: self.sideEffectContext)
    
    // and here we are finally able to start the queues
    self.isReady = true
    self.sideEffectQueue.resume()
    self.stateUpdaterQueue.resume()
    
    SharedStoreContainer.sharedStore = self
  }
  
  private func getState() -> S {
    assert(self.isReady, """
      The state is not ready yet. You should wait until the state is ready to invoke getState.
      If you are performing operations in the dependenciesContainer's init, then the suggested way to
      approach this is to dispatch an action. This will guarantee that the actions are dispatched correctly
    """)
    
    return self.state
  }
}

// MARK: State Updater management
fileprivate extension Store {
  private func enqueueStateUpdater(_ stateUpdater: AnyStateUpdater) -> Promise<Void> {
    let promise = Promise<Void>(in: .custom(queue: self.stateUpdaterQueue)) { [unowned self] resolve, reject, _ in
      let interceptorsChain = Store.chainedInterceptors(self.initializedInterceptors, with: self.manageUpdateState)
      try interceptorsChain(stateUpdater)
      resolve(())
    }
    
    // triggers the execution of the promise even though no one is listening for it
    return promise.void
  }
  
  private func manageUpdateState(_ dispatchable: Dispatchable) throws {
    guard self.isReady else {
      fatalError("Something is wrong, the state updater queue has been started before the initialization has been completed")
    }
    
    guard let stateUpdater = dispatchable as? AnyStateUpdater else {
      // interceptors changed the type.. let's re-dispatch it
      return self.nonPromisableDispatch(dispatchable)
    }
    
    let newState = stateUpdater.updatedState(currentState: self.state)
    
    guard let typedNewState = newState as? S else {
      preconditionFailure("Action updatedState returned a wrong state type")
    }
    
    self.state = typedNewState
    
    // listener are always invoked in the main queue
    DispatchQueue.main.async {
      self.listeners.values.forEach { $0() }
    }
  }
}

// MARK: Side Effect management
fileprivate extension Store {
  private func enqueueSideEffect(_ sideEffect: AnySideEffect) -> Promise<Void> {
    let promise = async(in: .custom(queue: self.sideEffectQueue), token: nil) { [unowned self] _ -> Void in
      let interceptorsChain = Store.chainedInterceptors(self.initializedInterceptors, with: self.manageSideEffect)
      try interceptorsChain(sideEffect)
    }
    
    return promise.void
  }
  
  private func manageSideEffect(_ dispatchable: Dispatchable) throws -> Void {
    guard self.isReady else {
      fatalError("Something is wrong, the side effect queue has been started before the initialization has been completed")
    }
    
    guard let sideEffect = dispatchable as? AnySideEffect else {
      // interceptor changed the type. Let's dispatch it
      return self.nonPromisableDispatch(dispatchable)
    }
    
    try sideEffect.sideEffect(self.sideEffectContext)
  }
}

// MARK: Action management
fileprivate extension Store {
  private func enqueueAction(_ action: Action) -> Promise<Void> {
    let promise = Promise<Void>(in: .custom(queue: self.stateUpdaterQueue)) { [unowned self] resolve, reject, _ in
      let interceptorsChain = Store.chainedInterceptors(self.initializedInterceptors, with: self.manageAction)
      try interceptorsChain(action)
      resolve(())
    }
    
    // triggers the execution of the promise even though no one is listening for it
    return promise.void
  }
  
  private func manageAction(_ dispatchable: Dispatchable) throws -> Void {
    guard self.isReady else {
      fatalError("Something is wrong, the side effect queue has been started before the initialization has been completed")
    }
    
    guard let action = dispatchable as? Action else {
      // interceptor changed the type. Let's dispatch it
      return self.nonPromisableDispatch(dispatchable)
    }
    
    let newState = action.updatedState(currentState: self.state)
    
    guard let typedNewState = newState as? S else {
      fatalError("Action updatedState returned a wrong state type")
    }
    
    let previousState = self.state
    self.state = typedNewState
    
    // executes the side effects, if needed
    self.triggerSideEffect(for: action, previousState: previousState, currentState: typedNewState)
    
    // listener are always invoked in the main queue
    DispatchQueue.main.async {
      self.listeners.values.forEach { $0() }
    }
  }
  
  /**
   Executes the side effect, if available
   
   - parameter action: the dispatched action
   - parameter previousState: the previous state
   - parameter currentState: the current state
   */
  fileprivate func triggerSideEffect(for action: Action, previousState: S, currentState: S) {
    guard let action = action as? ActionWithSideEffect else {
      return
    }
    
    if let async = action as? AnyAsyncAction, async.state != .loading {
      return
    }
    
    action.sideEffect(
      currentState: currentState,
      previousState: previousState,
      dispatch: self.nonPromisableDispatch,
      dependencies: self.dependencies
    )
  }
}

// MARK: Middleware management
fileprivate extension Store {
  /// Type used internally to store partially applied middleware (that is, a chain of middleware which doesn't handle the dispatchable item)
  fileprivate typealias InitializedInterceptor = (_ next: @escaping StoreInterceptorNext) -> (_ dispatchable: Dispatchable) throws -> Void
  fileprivate typealias ThrowingDispatch = (_: Dispatchable) throws -> Void
  
  /**
   This function composes the middleware chain in a single invokable function
   
   - parameter middleware:   the middleware to use
   - returns: a function that invokes all the middleware
   */
  fileprivate static func initializedInterceptors(
    _ interceptors: [StoreInterceptor],
    sideEffectContext: SideEffectContext<S, D>) -> [InitializedInterceptor] {
    
    return interceptors.map { interceptor in
      return interceptor(sideEffectContext)
    }
  }
  
  fileprivate static func chainedInterceptors(_ interceptors: [InitializedInterceptor], with lastStep: @escaping ThrowingDispatch) -> ThrowingDispatch {
    guard !interceptors.isEmpty else {
      return lastStep
    }
    
    guard interceptors.count > 1 else {
      return interceptors.first!(lastStep)
    }
    
    var m = interceptors
    let last = m.removeLast()
    
    return m.reduce(last(lastStep), { chain, middleware in
      return middleware(chain)
    })
  }
}
