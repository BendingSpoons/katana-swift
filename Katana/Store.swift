//
//  Store.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra

/// Type Erasure for `Store`
public protocol AnyStore: class {
  /// Type Erasure for the `Store` `state`
  var anyState: State { get }
  
  /**
   Dispatches a `Dispatchable` item
   
   - parameter dispatchable: the dispatchable to dispatch
   - returns: a promise that is resolved when the dispatchable is handled by the store
  */
  @discardableResult
  func dispatch<T: Dispatchable>(_ dispatchable: T) -> Promise<Void>

  @discardableResult
  func dispatch<T: SideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue>
  
  /**
   Adds a listener to the store. A listener is basically a closure that is invoked
   every time the Store's state changes
   
   - parameter listener: the listener closure
   - returns: a closure that can be used to remove the listener
   */
  func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe
}

/**
 Helper Store type that is used as a partial type.
 
 This type is very helpful when you want to pass the store to pieces of your application
 that must be aware of the type of state that the app manages but they should not care about
 the logic part (that is, the dependency container). A very common case is when you want to
 pass the store to the UI of your application. The UI shouldn't access to the dependency container
 directly (it should dispatch a `SideEffect` instead) but you can still have type-safety over the
 state type that is managed.
 
 - warning: you should not create this class directly. The class is meant to be used as a partial type
 erasure system over `Store`
*/
open class PartialStore<S: State>: AnyStore {
  /// Closure that is used to initialize the state
  public typealias StateInitializer<T: State> = () -> T

  /// The current state of the application
  open fileprivate(set) var state: S
  
  /**
   Implementation of the AnyStore protocol.
   
   - seeAlso: `AnyStore`
   */
  public var anyState: State {
    return self.state
  }
  
  /**
   Creates an instance of the `PartialStore` with the given initial state
   - parameter state: the initial state of the store
  */
  internal init(state: S) {
    self.state = state
  }
  
  /**
   Not implemented
   
   - warning: Not implemented. Instantiate a `Store` instead
  */
  @discardableResult
  public func dispatch<T: Dispatchable>(_ dispatchable: T) -> Promise<Void> {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }

  @discardableResult
  public func dispatch<T: SideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue> {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }
  
  /**
   Not implemented
   
   - warning: Not implemented. Instantiate a `Store` instead
  */
  public func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }
}

/// Creates an empty state
private func emptyStateInitializer<S: State>() -> S {
  return S()
}

/**
 The `Store` is a sort of single entry point that handles the logic of your application.
 In Katana, all the various pieces of information that your application manages should be stored
 in a single atom, called state (see also `State` protocol).
 
 The `Store`, however, doesn't really implements any application specific logic: this class
 only manages operations that are requsted by the application-specific logic. In particular,
 you can require the `Store` to execute something by `dispatching a dispatchable item`.

 Currently the store handles 3 types of dispatchable: `State Updater`, `Side Effect` and (deprecated) `Action`.
 
 #### Update the state
 As written before, in Katana every relevant information in the application should be stored in the
 Store's state. The only way to update the state is to dispatch a `StateUpdater` (or the legacy `Action`).
 At this point the `Store` will execute the following operations:
 
 - it executes the interceptors
 - it creates the new state, by invoking the `updateState` function of the `StateUpdater`
 - it updates the state
 - it resolves the promise
 
 #### Handle to Business Logic
 Non trivial applications require to interact with external services and/or implement complex logics.
 The proper way to handle these is by dispatching a `SideEffect`.
 The `Store` will execute the following operations:
 
 - it executes the interceptors
 - it executes the `SideEffect` body
 - it resolves the promise
 
 #### Listen for updates
 You can attach a listener that is invoked every time the state changes by using `addListener`.
 
 #### Intercept Dispatchable
 It is possible to intercept and reshape the behaviour of the `Store` by using a `StoreInterceptor`.
 A `StoreInterceptor` is executed every time something has dispatched, and before it is actually
 managed by the `Store`. Here you implement behaviours like logging, blocking items before they're executed
 and even change dynamically which dispatchable items arrive to the `Store` itself.
 
 - seeAlso: `StateUpdater` for more information about how to implement an update of the state
 - seeAlso: `SideEffect` for more information about how to implement an complex/asyncronous logic
 */
open class Store<S: State, D: SideEffectDependencyContainer>: PartialStore<S> {
  typealias ListenerID = String
  
  /// The  array of registered listeners
  fileprivate var listeners: [ListenerID: StoreListener]
  
  /// The array of middleware of the store
  fileprivate let interceptors: [StoreInterceptor]
  
  /// The initialized interceptors
  fileprivate var initializedInterceptors: [InitializedInterceptor]!
  
  /// Whether the store is ready to execute operations
  public private(set) var isReady: Bool
  
  /**
   The dependencies used in the actions side effects
   
   - seeAlso: `ActionWithSideEffect`
   */
  public var dependencies: D!
  
  /// The context passed to the side effect
  private var sideEffectContext: SideEffectContext<S, D>!
  
  /// The queue used to handle the `StateUpdater` items
  lazy fileprivate var stateUpdaterQueue: DispatchQueue = {
    let d = DispatchQueue(label: "katana.stateupdater", qos: .userInteractive)
    
    // queue is initially supended. The store will enable the queue when
    // all the setup is done.
    // we basically enqueue all the dispatched actions until
    // everything is needed to manage them is correctly sat up
    d.suspend()
    
    return d
  }()
  
  /// The queue used to handle the `SideEffect` items (and the `Action` ones as well)
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
   
   - parameter interceptors: a list of interceptors that are executed every time something is dispatched
   - returns: An instance of store
   */
  convenience public init(interceptors: [StoreInterceptor]) {
    self.init(
      interceptors: interceptors,
      stateInitializer: emptyStateInitializer
    )
  }
  
  /**
   The default init method for the Store.
   
   #### Initial phases
   When the store is created, it doesn't immediately start to handle dispatched items.
   Before that, in fact, the `Store` will (in order)
   * create the dependencies
   * create the first state version by using the given `stateInitializer`
   * initialise the interceptors

   Accessing the state before the `Store` is ready will lead to a crash of the application, as the
   state of the system is not well defined. You can check whether the `Store` is ready by leveraging the `isReady` property.
   
   A good pratice in case you have to interact with the `Store` (e.g., get the state) in the initial phases of your
   application is to dispatch a `SideEffect`. When dispatching something, in fact, the `Store` guarantees that
   items are managed only after that the `Store` is ready. Items dispatched during the initialization are suspended
   and resumed as soon as the `Store` is ready.
   
   - parameter interceptors: a list of interceptors that are executed every time something is dispatched
   - parameter stateInitializer: a closure invoked to define the first state's value
   - returns: An instance of store
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
  
  /**
   Dispatches a `Dispatchable` item
   
   #### Threading
   
   The `Store` follows strict rules about the parallelism with which dispatched items are handled.
   At the sime time, it tries to leverages as much as possible the modern multi-core systems that our
   devices offer.
   
   When a `StateUpdater` is dispatched, the Store enqueues it in a serial and syncronous queue. This means that the Store
   executes one update of the state at the time, following the order in which it has received them. This is done
   to guarantee the predictability of the changes to the state and avoid any race condition. In general, using a syncronous
   queue is never a big problem as any operation that goes in a `StateUpdater` is very lighweight.
   
   When it comes to `SideEffect` items, Katana will handle them in a parallel queue. A `SideEffect` is executed and considered
   done when its body finishes to be executed. This menas that side effects are not guaranteed to be run in isolation, and you
   should take into account the fact that multiple side effects can run at the same time. This decision has been taken to greately
   improve the performances of the system. Overall, this should not be a problem as you cannot really change
   the state of the system (that is, the store's state) without dispatching a `StateUpdater`.
   
   This version of the store keeps the support for `Action` items. Since actions both update the state and executes side effects,
   they are managed in the very same, serial and syncronous, queue of the `StateUpdater`. You are encouraged to move away from
   actions as soon as possible.
   
   #### Promise Resolution
   
   When it comes to `StateUpdater`, the promise is resolved when the state is updated. For `SideEffect`,
   the promise is resolved when the body of the `SideEffect` is executed entirely (see `SideEffect` documentation for
   more information). For `Action`, finally, the promise is resolved when the state is updated and the sideEffect method
   is executed (note that this doesn't mean that the side effect is effectively done, as there's no simple mechanism to
   block the execution of a sideeffect in an action)
   
   - parameter dispatchable: the dispatchable to dispatch
   - returns: a promise that is resolved when the dispatchable is handled by the store
  */
  @discardableResult
  override public func dispatch<T: SideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue> {
    return self.enqueueSideEffect(dispatchable).then { $0 as! T.ReturnValue }
  }

  @discardableResult
  override public func dispatch<T: Dispatchable>(_ dispatchable: T) -> Promise<Void> {
    if let _ = dispatchable as? AnyStateUpdater & AnySideEffect {
      fatalError("The parameter cannot implement both the state updater and the side effect")
    }
    
    if let stateUpdater = dispatchable as? AnyStateUpdater {
      return self.enqueueStateUpdater(stateUpdater).void
      
    } else if let sideEffect = dispatchable as? AnySideEffect {
      return self.enqueueSideEffect(sideEffect).void
      
    }
    
    fatalError("Invalid parameter")
  }

  @discardableResult
  func dispatch(_ dispatchable: Dispatchable) -> Promise<Void> {
    if let _ = dispatchable as? AnyStateUpdater & AnySideEffect {
      fatalError("The parameter cannot implement both the state updater and the side effect")
    }

    if let stateUpdater = dispatchable as? AnyStateUpdater {
      return self.enqueueStateUpdater(stateUpdater).void

    } else if let sideEffect = dispatchable as? AnySideEffect {
      return self.enqueueSideEffect(sideEffect).void

    }

    fatalError("Invalid parameter")
  }
  
  /**
   Private version of the `Dispatch` that doesn't return any promise
   
   - parameter dispatchable: the dispatchable to dispatch
  */
  fileprivate func nonPromisableDispatch(_ dispatchable: Dispatchable) {
    self.dispatch(dispatchable)
  }
}

// MARK: Private utilities
private extension Store {
  /**
   Creates and initializes the internal values.
   Store doesn't start to work (that is, actions are not dispatched) till this function is executed
   
   - parameter stateInitializer: the closure used to create the first configuration of the state
  */
  private func initializeInternalState(using stateInizializer: StateInitializer<S>) {
    self.state = stateInizializer()
    // invoke listeners (always in main queue)
    DispatchQueue.main.async {
      self.listeners.values.forEach { $0() }
    }
    self.initializedInterceptors = Store.initializedInterceptors(self.interceptors, sideEffectContext: self.sideEffectContext)
    
    // and here we are finally able to start the queues
    self.isReady = true
    self.sideEffectQueue.resume()
    self.stateUpdaterQueue.resume()
    
    SharedStoreContainer.sharedStore = self
  }
  
  /**
   Returns the current version of the state
   
   - returns: the current version of the state
   - warning: this method should not be invoked before the state is ready. The app will crash otherwise
   - seeAlso: `isReady`
  */
  private func getState() -> S {
    assert(self.isReady, """
      The state is not ready yet. You should wait until the state is ready to invoke getState.
      If you are performing operations in the dependenciesContainer's init, then the suggested way to
      approach this is to dispatch a side effect. This will guarantee that this method will work correctly
    """)
    
    return self.state
  }
}

// MARK: State Updater management
fileprivate extension Store {

  /**
   Enqueues a state updater.
   
   - parameter stateUpdater: the state updater to manage
   - returns: a promise that is resolved when the state updater is managed
  */
  private func enqueueStateUpdater(_ stateUpdater: AnyStateUpdater) -> Promise<Any> {
    let promise = Promise<Any>(in: .custom(queue: self.stateUpdaterQueue)) { [unowned self] resolve, reject, _ in
      let interceptorsChain = Store.chainedInterceptors(self.initializedInterceptors, with: self.manageUpdateState)
      try interceptorsChain(stateUpdater)
      resolve(())
    }
    
    // triggers the execution of the promise even though no one is listening for it
    promise.then(in: .background) { _ in }
    
    return promise
  }
  
  /**
   Handles the state updater. If the passed item doesn't conform to `StateUpdater`, then
   the item is simply dispatched again and not handled here.
   
   - parameter dispatchable: the item to handle
  */
  private func manageUpdateState(_ dispatchable: Dispatchable) throws {
    guard self.isReady else {
      fatalError("Something is wrong, the state updater queue has been started before the initialization has been completed")
    }
    
    guard let stateUpdater = dispatchable as? AnyStateUpdater else {
      // interceptors changed the type.. let's re-dispatch it
      return self.nonPromisableDispatch(dispatchable)
    }
    
    let logEnd = SignpostLogger.shared.logStart(type: .stateUpdater, name: stateUpdater.debugDescription)
    let newState = stateUpdater.updatedState(currentState: self.state)
    logEnd()
    
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
  
  /**
   Enqueues the side effect.
   
   - parameter sideEffect: the side effect to manage
   - returns: a promise that is resolved when the side effect is managed
  */
  private func enqueueSideEffect(_ sideEffect: AnySideEffect) -> Promise<Any> {
    let promise = async(in: .custom(queue: self.sideEffectQueue), token: nil) { [unowned self] _ -> Any in
//      let interceptorsChain = Store.chainedInterceptors(self.initializedInterceptors, with: self.manageSideEffect)
//      try interceptorsChain(sideEffect)
      return try self.manageSideEffect(sideEffect)
    }
    
    // triggers the execution of the promise even though no one is listening for it
    promise.then(in: .background) { $0 }
    
    return promise
  }
  
  /**
   Handles the side effect. If the passed item doesn't conform to `SideEffect`, then
   the item is simply dispatched again and not handled here.
   
   - parameter dispatchable: the item to handle
  */
  private func manageSideEffect(_ dispatchable: Dispatchable) throws -> Any {
    guard self.isReady else {
      fatalError("Something is wrong, the side effect queue has been started before the initialization has been completed")
    }
    
    guard let sideEffect = dispatchable as? AnySideEffect else {
      // interceptor changed the type. Let's dispatch it
      return self.nonPromisableDispatch(dispatchable)
    }
    
    let logEnd = SignpostLogger.shared.logStart(type: .sideEffect, name: dispatchable.debugDescription)
    let res = try sideEffect.anySideEffect(self.sideEffectContext)
    logEnd()
    return res
  }
}

// MARK: Middleware management
fileprivate extension Store {
  /**
    Type used internally to store partially applied interceptors.
    (that is, an interceptor to which the Store has already passed the context)
  */
  typealias InitializedInterceptor = (_ next: @escaping StoreInterceptorNext) -> (_ dispatchable: Dispatchable) throws -> Void
  
  /// Type used to define a dispatch that can throw
  typealias ThrowingDispatch = (_: Dispatchable) throws -> Void
  
  /**
   A function that initialises the given interceptors by binding the
   context.
   
   - parameter interceptors: the interceptors to use to create the chain
   - returns: an array of initialised interceptors
   */
  static func initializedInterceptors(
    _ interceptors: [StoreInterceptor],
    sideEffectContext: SideEffectContext<S, D>) -> [InitializedInterceptor] {
    
    return interceptors.map { interceptor in
      return interceptor(sideEffectContext)
    }
  }
  
  /**
   A function that chains the given interceptors with the given last step, which
   usually is the handling of the dispatchable items.
   
   - parameter interceptors: the interceptor to chain
   - parameter lastStep: the function to execute when all the intercepts are executed
   - returns: a single function that invokes all the interceptors and then the last step
  */
  static func chainedInterceptors(
    _ interceptors: [InitializedInterceptor],
    with lastStep: @escaping ThrowingDispatch) -> ThrowingDispatch {

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
