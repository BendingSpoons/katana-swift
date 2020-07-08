//
//  SideEffect.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra

/**
 Type erasure for `SideEffectContext`
 
 - seeAlso: `SideEffectContext`
 */
public protocol AnySideEffectContext {
  
  /// Type erased dependencies of the side effect
  var anyDependencies: SideEffectDependencyContainer { get }
  
  /**
   Type erased function that returns the current configuraiton of the state
   
   - returns: the type erased current configuration of the state
   */
  func getAnyState() -> State
  
  /**
   Dispatches a `Dispatchable`. It will esentially call the `anyDispatch` method of the backing store.
   
   - parameter dispatchable: the item to dispatch
   - returns: a promise that is resolved when the store finishes handling the dispatched item
   */
  @discardableResult
  func anyDispatch(_ dispatchable: Dispatchable) -> Promise<Any>
  
  /**
   Dispatches a `SideEffect`. It the type-safe version of the `anyDispatch` method
   
   - parameter dispatchable: the side effect to dispatch
   - returns: a promise that is resolved with the value returned by the side effect
              when the store finishes handling the dispatched item
   */
  @discardableResult
  func dispatch<T: SideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue>

  /**
  Dispatches a `ReturningSideEffect`. It is a partially erased version the `dispatch<T: SideEffect>(_:)` where only the return value is typed.

  - parameter dispatchable: the side effect to dispatch
  - returns: a promise that is resolved with the value returned by the side effect
             when the store finishes handling the dispatched item
  */
  @discardableResult
  func dispatch<T: ReturningSideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue>
  
  /**
   Dispatches a `AnyStateUpdater`. By considering that all the `StateUpdater`s are also `AnyStateUpdater`s this dispatch
   allows to dispatch all the possible `StateUpdaters` an app or a lib can implement.
   
   - parameter dispatchable: the side effect to dispatch
   - returns: a promise that is resolved when the store finishes updating the state
   */
  @discardableResult
  func dispatch<T: AnyStateUpdater>(_ dispatchable: T) -> Promise<Void>
}

/**
 Context passed to each side effect.
 
 The context is basically a wrapper of methods and utilities that the side effect
 can leverage to implement its functionalities
 */
public struct SideEffectContext<S, D> where S: State, D: SideEffectDependencyContainer {
  /**
   The dependencies passed to the `Store`. You can use this as a mechanism for
   dependencies injection.
   */
  public let dependencies: D
  
  /// The closure used to get the current version of the state
  private let getStateClosure: () -> S
  
  /// The closure that dispatches an item
  private let dispatchClosure: AnyDispatch
  
  /**
   Creates a new context.
   
   - parameter dependencies: the dependencies of the side effect
   - parameter getState: a closure that returns the current configuration of the state
   - parameter dispatch: a closure that dispatches an item
   */
  init(dependencies: D, getState: @escaping () -> S, dispatch: @escaping AnyDispatch) {
    self.dependencies = dependencies
    self.dispatchClosure = dispatch
    self.getStateClosure = getState
  }
  
  /**
   Function that returns the current configuration of the state
   
   - returns: the current configuration of the state
   */
  public func getState() -> S {
    return self.getStateClosure()
  }
  
  /**
   Dispatches a `SideEffect` item. This is the equivalent of the `Store` `dispatch`.
   
   - seeAlso: `Store` implementation of `dispatch`
   */
  @discardableResult
  public func dispatch<T: SideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue> {
    return self.dispatchClosure(dispatchable).then { $0 as! T.ReturnValue }
  }

  /**
  Dispatches a `ReturningSideEffect` item. This is the equivalent of the `Store` `dispatch`.

  - seeAlso: `Store` implementation of `dispatch`
  */
  @discardableResult
  public func dispatch<T: ReturningSideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue> {
    return self.dispatchClosure(dispatchable).then { $0 as! T.ReturnValue }
  }
  
  /**
   Dispatches an `AnyStateUpdater` item. This is the equivalent of the `Store` `dispatch`.
   
   - seeAlso: `Store` implementation of `dispatch`
   */
  @discardableResult
  public func dispatch<T: AnyStateUpdater>(_ dispatchable: T) -> Promise<Void> {
    return self.dispatchClosure(dispatchable).void
  }
  
  /**
   Dispatches a `Dispatchable` item. This is the equivalent of the `Store` `anyDispatch`.
   
   - seeAlso: `Store` implementation of `anyDispatch`
   */
  @discardableResult
  public func anyDispatch(_ dispatchable: Dispatchable) -> Promise<Any> {
    return self.dispatchClosure(dispatchable)
  }
}

/// Extension that contains some helper method
public extension AnySideEffectContext {
  /**
   Dispatches an item and wait for the related promise to be resolved.
   This is a shortcut for `try await(anyDispatch(item))`.
   
   - parameter dispatchable: the item to dispatch
   */
  func awaitDispatch(_ dispatchable: Dispatchable) throws {
    try await(self.anyDispatch(dispatchable))
  }
  
  /**
   Dispatches an item and wait for the related promise to be resolved.
   This is a shortcut for `try await(dispatch(item))`.
   
   - parameter dispatchable: the item to dispatch
   */
  func awaitDispatch<SE: SideEffect>(_ dispatchable: SE) throws -> SE.ReturnValue {
    return try await(self.dispatch(dispatchable))
  }
}

/// `SideEffectContext` conformance to `AnySideEffectContext`
extension SideEffectContext: AnySideEffectContext {
  
  /// Implementation of the `anyDependencies` requirement for `AnySideEffectContext`
  public var anyDependencies: SideEffectDependencyContainer {
    return self.dependencies
  }
  
  /// Implementation of the `getAnyState` requirement for `AnySideEffectContext`
  public func getAnyState() -> State {
    return self.getState()
  }
}

/**
 Type erasure for `SideEffect`
 
 - seeAlso: `SideEffect`
 */
public protocol AnySideEffect: Dispatchable {
  /**
   Block that implements the logic of the side effect.
   - parameter context: the context of the side effect
   - throws: if the logic has an error. The related promise will be rejected
   - returns: the side effect return value, if applicable
   - seeAlso: `SideEffect`
   */
  func anySideEffect(_ context: AnySideEffectContext) throws -> Any
}

/**
 Partial type erasure for `SideEffect`. The return value is the only thing typed, while the context is erased

 - seeAlso: `SideEffect`
 */
public protocol ReturningSideEffect: AnySideEffect {
  /// The type of the return value
  associatedtype ReturnValue

  /**
    Implements the logic of the side effect.
    - parameter context: the context of the side effect
    - throws: if the logic has an error. The related promise will be rejected
    - returns: the side effect return value, if applicable
    - seeAlso: `SideEffect`
   */
  func returningSideEffect(_ context: AnySideEffectContext) throws -> ReturnValue
}

/// Conformance of `ReturningSideEffect` to `AnySideEffect`
public extension ReturningSideEffect {

  /// Implementation of the `anySideEffect` requirement for `ReturningSideEffectContext`
  func anySideEffect(_ context: AnySideEffectContext) throws -> Any {
    return try self.returningSideEffect(context)
  }
}

/**
 A side effect is a single atom of the logic of your application.
 While you can actually use them as you desire, the idea is to implement in each side effect
 a meaningful, self contained, piece of logic that can be used from other pieces of you application
 (e.g., dispatched by a View Controller or by another side effect).
 
 The `StateUpdater` is strongly tied to the state that it handles and the dependencies it has.
 This greatily simplifies the code written in normal situations.
 However, if you need to create updaters that are not strictly tied to a concrete types (e.g., in a library)
 you can use `AnySideEffect`.
 
 ### App Tips & Tricks
 To further simplify the usage of a `StateUpdater` you can add to your application a helper protocol
 ```swift
 /// assuming `AppState` is the type of your application's state and `DependenciesContainer` is the
 /// container of your dependencies
 protocol AppSideEffect: SideEffect where StateType == AppState, Dependencies == DependenciesContainer {}
 ```
 
 By conforming to `AppSideEffect`, you will get better autocompletion
 */
public protocol SideEffect: ReturningSideEffect {
  /// The type of the state of the store
  associatedtype StateType: State
  
  /// The type of the dependencies container that is used to pass dependencies to the side effect
  associatedtype Dependencies: SideEffectDependencyContainer
  
  /// The type of the side effect's return value, that will be used to parameterize the related promise
  associatedtype ReturnValue
  
  /**
   Block that implements the logic of the side effect.
   You can implement the logic, leveraging the technology you desire for threading and flow management.
   
   However, there are two patterns that Katana suggests to use: synchronous side effects and asynchronous side effects
   
   #### Syncronous
   A synchronous side effect is a side effect that finishes its execution when the `sideEffect(:)` method
   is completed. Since the related promise (that is, the promise that is returned when the side effect is dispatched)
   is resolved when this method ends, it means that the caller can safely assume that the operations are completed.
   
   The easier way to achieve this behaviour is by using `await` offered by the `Hydra` library. You can use `await`
   with any API that returns a promise (e.g., the dispatch) and it blocks the execution of the method until the
   promise is resolved (you can find more documentation here https://github.com/malcommac/Hydra/#awaitasync).
   
   This should be the default approach you take for your side effects
   
   #### Asynchronous
   An asynchronous side effect is a side effect that continues to propagate its effect even after the `sideEffect(:)` method
   has been completed. This can be very helpful for very long running operations where you don't want to block
   other side effects in the queue.
   
   In order to do use this approach, you can simply apply any asynchronous technique you know that does not block the method
   (e.g.: promise, callback).
   
   This approach is not suggested and should be used only in rare cases
   
   - parameter context: the context of the side effect
   - returns: the side effect return value that will be used to parameterize the related promise
   - throws: if the logic has an error. The related promise will be rejected
   - seeAlso: https://github.com/malcommac/Hydra/#awaitasync
   */
  func sideEffect(_ context: SideEffectContext<StateType, Dependencies>) throws -> ReturnValue
}

/// Conformance of `SideEffect` to `ReturningSideEffect`
public extension SideEffect {
  /// Implementation of the `returningSideEffect` requirement for `ReturningSideEffectContext`
  func returningSideEffect(_ context: AnySideEffectContext) throws -> Self.ReturnValue {
    guard let typedSideEffect = context as? SideEffectContext<StateType, Dependencies> else {
      fatalError("Invalid context pased to side effect")
    }
    
    return try self.sideEffect(typedSideEffect)
  }
}
