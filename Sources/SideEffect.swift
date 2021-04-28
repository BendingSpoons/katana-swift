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
   Type erased function that returns the current configuration of the state

   - returns: the type erased current configuration of the state
   */
  func getAnyState() -> State

  /**
   Dispatches a `Dispatchable`. It will essentially call the `anyDispatch` method of the backing store.

   - parameter dispatchable: the item to dispatch
   - returns: a promise that is resolved when the store finishes handling the dispatched item
   */
  @discardableResult
  func anyDispatch(_ dispatchable: Dispatchable) -> Promise<Any>

  /**
   Dispatches a `AnySideEffect`.

   - parameter dispatchable: the `AnySideEffect` to dispatch
   - returns: a promise that is resolved with the value returned by the side effect
              when the store finishes handling the dispatched item
   */
  @discardableResult
  func dispatch<T: AnySideEffect>(_ dispatchable: T) -> Promise<Void>

  /**
   Dispatches a `AnyStateUpdater`.

   - parameter dispatchable: the side effect to dispatch
   - returns: a promise that is resolved when the store finishes updating the state
   */
  @discardableResult
  func dispatch<T: AnyStateUpdater>(_ dispatchable: T) -> Promise<Void>

  /**
   Dispatches a `ReturningSideEffect`

   - parameter dispatchable: the `ReturningSideEffect` to dispatch
   - returns: a promise that is resolved with the value returned by the side effect
              when the store finishes handling the dispatched item
   */
  @discardableResult
  func dispatch<T: ReturningSideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue>
}

extension AnySideEffectContext {
  /// Default implementation of the `dispatch<T: AnyStateUpdater>`
  @discardableResult
  public func dispatch<T: AnyStateUpdater>(_ dispatchable: T) -> Promise<Void> {
    return self.anyDispatch(dispatchable).voidInBackground
  }

  /// Default implementation of the `dispatch<T: AnySideEffect>`
  @discardableResult
  public func dispatch<T: AnySideEffect>(_ dispatchable: T) -> Promise<Void> {
    return self.anyDispatch(dispatchable).voidInBackground
  }

  /// Default implementation of the `dispatch<T: ReturningSideEffect>`
  @discardableResult
  public func dispatch<T: ReturningSideEffect>(_ dispatchable: T) -> Promise<T.ReturnValue> {
    return self.anyDispatch(dispatchable).then(in: .background) { $0 as! T.ReturnValue }
  }
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
   Dispatches a `Dispatchable` item. This is the equivalent of the `Store` `anyDispatch`.

   - seeAlso: `Store` implementation of `anyDispatch`
   */
  @discardableResult
  public func anyDispatch(_ dispatchable: Dispatchable) -> Promise<Any> {
    return self.dispatchClosure(dispatchable)
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
 Type erasure for `SideEffect` and `ReturningSideEffect`

 - seeAlso: `SideEffect`, `ReturningSideEffect`
 */
public protocol AnySideEffect: Dispatchable {
  /**
   Block that implements the logic of the side effect.
   - parameter context: the context of the side effect
   - throws: if the logic has an error. The related promise will be rejected
   - returns: the side effect return value, if applicable
   - seeAlso: `SideEffect`, `ReturningSideEffect`
   */
  func anySideEffect(_ context: AnySideEffectContext) throws -> Any
}

/**
 A `AnySideEffect` that is capable of returning a typed value.

 In order to promote reusability of the logic written using this type, both the state and
 the dependencies are erased. This helps tremendously when writing libraries and generic
 logic, and it can also be extended to be used in the apps.

 For example, if the app needs to use a typed returning side effect it can define something like:

 ```
 protocol AppReturningSideEffect: ReturningSideEffect {
   typealias StateType = AppState
   typealias Dependencies = AppDependencies

   func sideEffect(_ context: SideEffectContext<StateType, Dependencies>) throws -> ReturnType
 }

 extension AppReturningSideEffect {
   func sideEffect(_ context: AnySideEffectContext) throws -> ReturnValue {
     guard let typedContext = context as? SideEffectContext<StateType, Dependencies> else {
       fatalError("Invalid context pased to side effect")
     }

     return try self.sideEffect(typedContext)
   }
 }
 ```

 - seeAlso: `AnySideEffect`, `SideEffect`
 */
public protocol ReturningSideEffect: AnySideEffect {
  /// The type of the return value
  associatedtype ReturnValue

  /**
    Implements the logic of the side effect.
    - parameter context: the context of the side effect
    - throws: if the logic has an error. The related promise will be rejected
    - returns: the side effect return value, if applicable
    - seeAlso: `AnySideEffect`
   */
  func sideEffect(_ context: AnySideEffectContext) throws -> ReturnValue
}

/// Conformance of `ReturningSideEffect` to `AnySideEffect`
extension ReturningSideEffect {
  /// Implementation of the `anySideEffect` requirement for `ReturningSideEffectContext`
  public func anySideEffect(_ context: AnySideEffectContext) throws -> Any {
    return try self.sideEffect(context)
  }
}

/**
 A side effect is a single atom of the logic of your application.
 While you can actually use them as you desire, the idea is to implement in each side effect
 a meaningful, self contained, piece of logic that can be used from other pieces of you application
 (e.g., dispatched by a View Controller or by another side effect).

 The `SideEffect` is strongly tied to the state that it handles and the dependencies it has.
 This greatly simplifies the code written in normal situations.
 However, if you need to create updaters that are not strictly tied to a concrete types (e.g., in a library)
 you can use `AnySideEffect`.

 ### App Tips & Tricks
 To further simplify the usage of a `SideEffect` you can add to your application a helper protocol
 ```swift
 /// assuming `AppState` is the type of your application's state and `DependenciesContainer` is the
 /// container of your dependencies
 protocol AppSideEffect: SideEffect where StateType == AppState, Dependencies == DependenciesContainer {}
 ```

 By conforming to `AppSideEffect`, you will get better autocompletion
 */
public protocol SideEffect: AnySideEffect {
  /// The type of the state of the store
  associatedtype StateType: State

  /// The type of the dependencies container that is used to pass dependencies to the side effect
  associatedtype Dependencies: SideEffectDependencyContainer

  /**
   Block that implements the logic of the side effect.
   You can implement the logic, leveraging the technology you desire for threading and flow management.

   However, there are two patterns that Katana suggests to use: synchronous side effects and asynchronous side effects

   #### Synchronous
   A synchronous side effect is a side effect that finishes its execution when the `sideEffect(:)` method
   is completed. Since the related promise (that is, the promise that is returned when the side effect is dispatched)
   is resolved when this method ends, it means that the caller can safely assume that the operations are completed.

   The easier way to achieve this behaviour is by using `Hydra.await` offered by the `Hydra` library. You can use `Hydra.await`
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
  func sideEffect(_ context: SideEffectContext<StateType, Dependencies>) throws
}

/// Conformance of `SideEffect` to `ReturningSideEffect`
extension SideEffect {
  public func anySideEffect(_ context: AnySideEffectContext) throws -> Any {
    guard let typedSideEffect = context as? SideEffectContext<StateType, Dependencies> else {
      fatalError("Invalid context pased to side effect")
    }

    try self.sideEffect(typedSideEffect)
    return ()
  }
}

extension Promise {
  /// Maps a promise hiding the return type. Note that this new promise
  /// runs in the background
  fileprivate var voidInBackground: Promise<Void> {
    return self.then(in: .background) { _ in }
  }
}
