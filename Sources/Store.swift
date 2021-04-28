//
//  Store.swift
//  Katana
//
//  Copyright © 2021 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra

/// Type Erasure for `Store`
public protocol AnyStore: AnyObject {
  /// Type Erasure for the `Store` `state`
  var anyState: State { get }

  /**
   Dispatches a generic `Dispatchable` item. This is useful for customizing Katana's dispatchable, for example in other libraries.

   - parameter dispatchable: the item to dispatch
   - returns: a promise that is resolved when the dispatchable is handled by the store, resolving to a value associated with the dispatchable
   */
  @discardableResult
  func anyDispatch(_ dispatchable: Dispatchable) -> Promise<Any>

  /**
   Dispatches an `AnyStateUpdater` item

   - parameter dispatchable: the State Updater to dispatch
   - returns: a promise that is resolved when the dispatchable is handled by the store
   */
  @discardableResult
  func dispatch<T: AnyStateUpdater>(_ dispatchable: T) -> Promise<Void>

  /**
   Dispatches an `AnySideEffect` item

   - parameter dispatchable: the State Updater to dispatch
   - returns: a promise that is resolved when the dispatchable is handled by the store
   */
  @discardableResult
  func dispatch<T: AnySideEffect>(_ dispatchable: T) -> Promise<Void>

  /**
   Dispatches a `ReturningSideEffect` item

   - parameter dispatchable: the Returning Side Effect to dispatch
   - returns: a promise parameterized to the side effect's return value, that is resolved when the dispatchable is handled by the store
   */
  @discardableResult
  func dispatch<T: ReturningSideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue>

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
  public func anyDispatch(_: Dispatchable) -> Promise<Any> {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }

  /**
   Not implemented

   - warning: Not implemented. Instantiate a `Store` instead
   */
  @discardableResult
  public func dispatch<T: AnyStateUpdater>(_: T) -> Promise<Void> {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }

  /**
   Not implemented

   - warning: Not implemented. Instantiate a `Store` instead
   */
  @discardableResult
  public func dispatch<T: AnySideEffect>(_: T) -> Promise<Void> {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }

  /**
   Not implemented

   - warning: Not implemented. Instantiate a `Store` instead
   */
  @discardableResult
  public func dispatch<T: ReturningSideEffect>(_: T) -> Promise<T.ReturnValue> {
    fatalError("This should not be invoked, as PartialStore should never be used directly. Use Store instead")
  }

  /**
   Not implemented

   - warning: Not implemented. Instantiate a `Store` instead
   */
  public func addListener(_: @escaping StoreListener) -> StoreUnsubscribe {
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
 only manages operations that are requested by the application-specific logic. In particular,
 you can require the `Store` to execute something by `dispatching a dispatchable item`.

 Currently the store handles 2 types of dispatchable: `State Updater`, `Side Effect`

 #### Update the state
 As written before, in Katana every relevant information in the application should be stored in the
 Store's state. The only way to update the state is to dispatch a `StateUpdater`.
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
 - seeAlso: `SideEffect` for more information about how to implement a complex/asynchronous logic
 */
open class Store<S: State, D: SideEffectDependencyContainer>: PartialStore<S> {
  /// Closure that is used to initialize the dependencies
  public typealias DependenciesInitializer = (_ dispatch: @escaping AnyDispatch, _ getState: @escaping StateInitializer<S>) -> D

  typealias ListenerID = String

  /// The  array of registered listeners
  fileprivate var listeners: [ListenerID: StoreListener]

  /// The array of middleware of the store
  fileprivate let interceptors: [StoreInterceptor]

  /// The initialized interceptors
  fileprivate var initializedInterceptors: [InitializedInterceptor]!

  /// Whether the store is ready to execute operations
  public private(set) var isReady: Bool

  /// The dependencies used in the side effects
  ///
  /// - seeAlso: `SideEffect`
  public var dependencies: D!

  /// The context passed to the side effect
  private var sideEffectContext: SideEffectContext<S, D>!

  /// AsyncProvider used to run all the listeners
  private var listenersAsyncProvider: AsyncProvider

  /// The queue used to handle the `StateUpdater` items
  fileprivate var stateUpdaterQueue: DispatchQueue = {
    let d = DispatchQueue(label: "katana.stateupdater", qos: .userInteractive)

    // queue is initially suspended. The store will enable the queue when
    // all the setup is done.
    // we basically enqueue all the dispatched dispatchables until
    // everything is needed to manage them is correctly sat up
    d.suspend()

    return d
  }()

  /// The queue used to handle the `SideEffect` items
  fileprivate var sideEffectQueue: DispatchQueue = {
    let d = DispatchQueue(label: "katana.sideEffect", qos: .userInteractive, attributes: .concurrent)
    // queue is initially suspended. The store will enable the queue when
    // all the setup is done.
    // we basically enqueue all the dispatched dispatchables until
    // everything is needed to manage them is correctly sat up
    d.suspend()

    return d
  }()

  /**
   A convenience init method. The store won't have middleware nor dependencies for the side effects.
   The state will be created using the default init of the state

   - returns: An instance of store
   */
  public convenience init() {
    self.init(interceptors: [], stateInitializer: emptyStateInitializer)
  }

  /**
   A convenience init method for the Store. The initial state will be created using the default
   init of the state type.

   - parameter interceptors: a list of interceptors that are executed every time something is dispatched
   - returns: An instance of the store
   */
  public convenience init(interceptors: [StoreInterceptor]) {
    self.init(
      interceptors: interceptors,
      stateInitializer: emptyStateInitializer
    )
  }

  /**
   A convenience init method for the Store. The dependencies will be created using the default init of the dependency type.

   - parameter interceptors: a list of interceptors that are executed every time something is dispatched
   - parameter stateInitializer: a closure invoked to define the first state's value
   - parameter configuration: the configuration needed by the store to start properly
   - returns: An instance of the store
   */
  public convenience init(
    interceptors: [StoreInterceptor],
    stateInitializer: @escaping StateInitializer<S>,
    configuration: Configuration = .init()
  ) {
    self.init(
      interceptors: interceptors,
      stateInitializer: stateInitializer,
      dependenciesInitializer: { dispatch, getState in D(dispatch: dispatch, getState: getState) },
      configuration: configuration
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

   A good practice in case you have to interact with the `Store` (e.g., get the state) in the initial phases of your
   application is to dispatch a `SideEffect`. When dispatching something, in fact, the `Store` guarantees that
   items are managed only after that the `Store` is ready. Items dispatched during the initialization are suspended
   and resumed as soon as the `Store` is ready.

   - parameter interceptors: a list of interceptors that are executed every time something is dispatched
   - parameter stateInitializer: a closure invoked to define the first state's value
   - parameter dependenciesInitializer: a closure invoked to instantiate the dependencies
   - parameter configuration: the configuration needed by the store to start properly
   - returns: An instance of store
   */
  public init(
    interceptors: [StoreInterceptor],
    stateInitializer: @escaping StateInitializer<S>,
    dependenciesInitializer: @escaping DependenciesInitializer,
    configuration: Configuration = .init()
  ) {
    self.listenersAsyncProvider = configuration.listenersAsyncProvider

    self.listeners = [:]
    self.interceptors = interceptors
    self.isReady = false

    let emptyState: S = emptyStateInitializer()
    super.init(state: emptyState)

    self.dependencies = dependenciesInitializer(self.anyDispatchClosure, self.getStateClosure)

    self.sideEffectContext = SideEffectContext<S, D>(
      dependencies: self.dependencies,
      getState: self.getStateClosure,
      dispatch: self.anyDispatchClosure
    )

    /// Do the initialization operation async to avoid to block the store init caller
    /// which in a standard application is the AppDelegate. WatchDog may decide to kill the app
    /// if the stateInitializer function takes too much to do its job and we block the app's startup
    configuration.stateInitializerAsyncProvider.execute { [unowned self] in
      self.initializeInternalState(using: stateInitializer)
    }

    self.invokeListeners()
  }

  /// The `anyDispatch` method as a closure which does not capture `self` to avoid reference loops
  private var anyDispatchClosure: AnyDispatch {
    return { [unowned self] dispatchable in
      self.anyDispatch(dispatchable)
    }
  }

  /// The `getState` method as a closure which does not capture `self` to avoid reference loops
  private var getStateClosure: () -> S {
    return { [unowned self] in
      self.getState()
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
   Dispatches a `ReturningSideEffect` item

   #### Threading

   The `Store` follows strict rules about the parallelism with which dispatched items are handled.
   At the same time, it tries to leverages as much as possible the modern multi-core systems that our
   devices offer.

   When a `ReturningSideEffect` is dispatched, Katana will handle them in a parallel queue. A `ReturningSideEffect` is executed and considered
   done when its body finishes to be executed. This means that side effects are not guaranteed to be run in isolation, and you
   should take into account the fact that multiple side effects can run at the same time. This decision has been taken to greatly
   improve the performances of the system. Overall, this should not be a problem as you cannot really change
   the state of the system (that is, the store's state) without dispatching a `ReturningSideEffect`.

   #### Promise Resolution

   When it comes to `ReturningSideEffect`s, the promise is resolved when the body of the `ReturningSideEffect` is executed entirely (see
   `ReturningSideEffect` documentation for more information).

   - parameter dispatchable: the side effect to dispatch
   - returns: a promise parameterized to SideEffect's return value, that is resolved when the SideEffect is handled by the store
   */
  @discardableResult
  override public func dispatch<T: ReturningSideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue> {
    return self.enqueueSideEffect(dispatchable)
  }

  /**
   Dispatches a `AnySideEffect` item

   #### Threading

   The `Store` follows strict rules about the parallelism with which dispatched items are handled.
   At the same time, it tries to leverages as much as possible the modern multi-core systems that our
   devices offer.

   When a `AnySideEffect` is dispatched, Katana will handle them in a parallel queue. A `AnySideEffect` is executed and considered
   done when its body finishes to be executed. This means that side effects are not guaranteed to be run in isolation, and you
   should take into account the fact that multiple side effects can run at the same time. This decision has been taken to greatly
   improve the performances of the system. Overall, this should not be a problem as you cannot really change
   the state of the system (that is, the store's state) without dispatching a `AnySideEffect`.

   #### Promise Resolution

   When it comes to `AnySideEffect`s, the promise is resolved when the body of the `AnySideEffect` is executed entirely (see
   `AnySideEffect` documentation for more information).

   - parameter dispatchable: the side effect to dispatch
   - returns: a promise parameterized to SideEffect's return value, that is resolved when the SideEffect is handled by the store
   */
  @discardableResult
  override public func dispatch<T: AnySideEffect>(_ dispatchable: T) -> Promise<Void> {
    self.enqueueSideEffect(dispatchable)
  }

  /**
   Dispatches a `Dispatchable` item

   #### Threading

   The `Store` follows strict rules about the parallelism with which dispatched items are handled.
   At the same time, it tries to leverages as much as possible the modern multi-core systems that our
   devices offer.

   When an `AnyStateUpdater` is dispatched, the Store enqueues it in a serial and synchronous queue. This means that the Store
   executes one update of the state at the time, following the order in which it has received them. This is done
   to guarantee the predictability of the changes to the state and avoid any race condition. In general, using a synchronous
   queue is never a big problem as any operation that goes in an `AnyStateUpdater` is very lightweight.

   #### Promise Resolution

   When it comes to `AnyStateUpdater`, the promise is resolved when the state is updated.

   - parameter dispatchable: the state updater to dispatch
   - returns: a promise parameterized to void that is resolved when the state updater is handled by the store
   */
  @discardableResult
  override public func dispatch<T: AnyStateUpdater>(_ dispatchable: T) -> Promise<Void> {
    return self.enqueueStateUpdater(dispatchable)
  }

  /**
   Dispatches a `Dispatchable` item

   #### Threading

   The `Store` follows strict rules about the parallelism with which dispatched items are handled.
   At the same time, it tries to leverages as much as possible the modern multi-core systems that our
   devices offer.

   When a `StateUpdater` is dispatched, the Store enqueues it in a serial and synchronous queue. This means that the Store
   executes one update of the state at the time, following the order in which it has received them. This is done
   to guarantee the predictability of the changes to the state and avoid any race condition. In general, using a synchronous
   queue is never a big problem as any operation that goes in a `StateUpdater` is very lighweight.

   When it comes to `SideEffect` items, Katana will handle them in a parallel queue. A `SideEffect` is executed and considered
   done when its body finishes to be executed. This means that side effects are not guaranteed to be run in isolation, and you
   should take into account the fact that multiple side effects can run at the same time. This decision has been taken to greatly
   improve the performances of the system. Overall, this should not be a problem as you cannot really change
   the state of the system (that is, the store's state) without dispatching a `StateUpdater`.

   #### Promise Resolution

   When it comes to `StateUpdater`, the promise is resolved when the state is updated. For `SideEffect`,
   the promise is resolved when the body of the `SideEffect` is executed entirely (see `SideEffect` documentation for
   more information).

   - parameter dispatchable: the dispatchable to dispatch, it can be either a StateUpdater or a SideEffect
   - returns: a promise that is resolved when the dispatchable is handled by the store
   */
  @discardableResult
  override public func anyDispatch(_ dispatchable: Dispatchable) -> Promise<Any> {
    if let _ = dispatchable as? AnyStateUpdater & AnySideEffect {
      fatalError("The parameter cannot implement both the state updater and the side effect")
    }

    if let stateUpdater = dispatchable as? AnyStateUpdater {
      return self.enqueueStateUpdater(stateUpdater).then(in: .background) { _ in }

    } else if let sideEffect = dispatchable as? AnySideEffect {
      return self.enqueueSideEffect(sideEffect).then(in: .background) { (value: Any) in value }
    }

    fatalError("Invalid parameter")
  }

  /**
   Private version of the `Dispatch` that doesn't return any promise

   - parameter dispatchable: the dispatchable to dispatch
   */
  fileprivate func nonPromisableDispatch(_ dispatchable: Dispatchable) {
    self.anyDispatch(dispatchable)
  }

  /// The dependencies used to initialize katana
  public struct Configuration {
    /// AsyncProvider used to run the state initializer
    let stateInitializerAsyncProvider: AsyncProvider

    /// AsyncProvider used to run all the listeners
    let listenersAsyncProvider: AsyncProvider

    public init(
      stateInitializerAsyncProvider: AsyncProvider = DispatchQueue.main,
      listenersAsyncProvider: AsyncProvider = DispatchQueue.main
    ) {
      self.stateInitializerAsyncProvider = stateInitializerAsyncProvider
      self.listenersAsyncProvider = listenersAsyncProvider
    }
  }
}

// MARK: Private utilities

extension Store {
  /**
   Creates and initializes the internal values.
   Store doesn't start to work (that is, dispatchables are not dispatched) until this function is executed

   - parameter stateInitializer: the closure used to create the first configuration of the state
   */
  private func initializeInternalState(using stateInizializer: StateInitializer<S>) {
    self.state = stateInizializer()
    self.initializedInterceptors = Store.initializedInterceptors(self.interceptors, sideEffectContext: self.sideEffectContext)

    // and here we are finally able to start the queues
    self.isReady = true
    self.sideEffectQueue.resume()
    self.stateUpdaterQueue.resume()
  }

  /// Invoke all the registered listeners in the configured async provider
  private func invokeListeners() {
    self.listenersAsyncProvider.execute { [weak self] () in
      guard let self = self else { return }

      self.listeners.values.forEach { $0() }
    }
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

extension Store {
  /**
   Enqueues a state updater.

   - parameter stateUpdater: the state updater to manage
   - returns: a promise that is resolved when the state updater is managed
   */
  private func enqueueStateUpdater(_ stateUpdater: AnyStateUpdater) -> Promise<Void> {
    let promise = Promise<Void>(in: .custom(queue: self.stateUpdaterQueue)) { [unowned self] resolve, _, _ in
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
      // Interceptors changed the dispatchable type. Let's re-dispatch it
      return self.nonPromisableDispatch(dispatchable)
    }

    let logEnd = SignpostLogger.shared.logStart(type: .stateUpdater, name: stateUpdater.debugDescription)
    let newState = stateUpdater.updatedState(currentState: self.state)
    logEnd()

    guard let typedNewState = newState as? S else {
      preconditionFailure("StateUpdater updatedState returned a wrong state type")
    }

    self.state = typedNewState

    self.invokeListeners()
  }
}

// MARK: Side Effect management

extension Store {
  /**
   Enqueues the side effect.

   - parameter sideEffect: the side effect to manage
   - returns: a promise parameterized to the side effect's return value that is resolved when the side effect is managed
   */
  private func enqueueSideEffect<ReturnValue>(_ sideEffect: AnySideEffect) -> Promise<ReturnValue> {
    let promise = async(in: .custom(queue: self.sideEffectQueue), token: nil) { [unowned self] _ -> ReturnValue in
      var sideEffectValue: Any?

      let executeSideEffect: StoreInterceptorNext = {
        sideEffectValue = try self.manageSideEffect($0)
      }

      let interceptorsChain = Store.chainedInterceptors(self.initializedInterceptors, with: executeSideEffect)
      try interceptorsChain(sideEffect)

      guard let value = sideEffectValue as? ReturnValue else {
        fatalError("""
          It looks like you've used an interceptor that either stopped the execution of the side effect or changed the executed side effect.
          This is not longer supported as of Katana 4.0
        """)
      }

      return value
    }

    promise.then(in: .background) { _ in }

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
      // Interceptors changed the dispatchable type. Let's re-dispatch it
      return self.nonPromisableDispatch(dispatchable)
    }

    let logEnd = SignpostLogger.shared.logStart(type: .sideEffect, name: dispatchable.debugDescription)
    let res = try sideEffect.anySideEffect(self.sideEffectContext)
    logEnd()
    return res
  }
}

// MARK: Middleware management

extension Store {
  /**
   Type used internally to store partially applied interceptors.
   (that is, an interceptor to which the Store has already passed the context)
   */
  fileprivate typealias InitializedInterceptor = (_ next: @escaping StoreInterceptorNext)
    -> (_ dispatchable: Dispatchable) throws -> Void

  /// Type used to define a dispatch that can throw
  fileprivate typealias ThrowingDispatch = (_: Dispatchable) throws -> Void

  /**
   A function that initialises the given interceptors by binding the
   context.

   - parameter interceptors: the interceptors to use to create the chain
   - returns: an array of initialised interceptors
   */
  fileprivate static func initializedInterceptors(
    _ interceptors: [StoreInterceptor],
    sideEffectContext: SideEffectContext<S, D>
  ) -> [InitializedInterceptor] {
    return interceptors.map { interceptor in
      return interceptor(sideEffectContext)
    }
  }

  /**
   A function that chains the given interceptors with the given last step, which
   usually is the handling of the dispatchable items.

   - parameter interceptors: the interceptor to chain
   - parameter lastStep: the function to execute when all the interceptors have been executed
   - returns: a single function that invokes all the interceptors and then the last step
   */
  fileprivate static func chainedInterceptors(
    _ interceptors: [InitializedInterceptor],
    with lastStep: @escaping ThrowingDispatch
  ) -> ThrowingDispatch {
    guard !interceptors.isEmpty else {
      return lastStep
    }

    guard interceptors.count > 1 else {
      return interceptors.first!(lastStep)
    }

    // reversing the chain to oppose the matryoshka effect of its execution
    // so the interceptors will be executed in the same order they are given

    var m = interceptors
    let last = m.removeLast()

    return m.reversed().reduce(last(lastStep)) { chain, middleware in
      return middleware(chain)
    }
  }
}
