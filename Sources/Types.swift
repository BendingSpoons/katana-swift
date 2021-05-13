//
//  Types.swift
//  Katana
//
//  Copyright © 2021 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra

/**
 Typealias for the type erased function that is invoked when the state changes.

 - parameter oldState: the state before the update
 - parameter newState: the state after the update
 */
public typealias AnyStoreListener = (_ oldState: State, _ newState: State) -> Void

/**
 Typealias for the function that is invoked when the state changes.

 - parameter oldState: the state before the update
 - parameter newState: the state after the update
 */
public typealias StoreListener<S: State> = (_ oldState: S, _ newState: S) -> Void

/// Typealias for the `Store` listener unsubscribe closure
public typealias StoreUnsubscribe = () -> Void

/// Typealias for a type that returns the `Store`'s state
public typealias GetState = () -> State

/// Typealias for the `Store.anyDispatch` function with the ability of managing the output with a promise
public typealias AnyDispatch = (_: Dispatchable) -> Promise<Any>

/// See `Executor`
@available(*, deprecated, message: "Use the new `Executor` instead")
public typealias AsyncProvider = Executor

/// Entity capable of executing a closure. This can be useful in tests to control where and when tasks
/// are executed.
///
/// - warning: Katana assumes that implementations of this protocol will always guarantee that the tasks
/// given as arguments are never executed in parallel.
public protocol Executor {
  /// Calling this method will enqueue a task to be executed asynchronously
  @available(*, deprecated, message: "Use the new `executeAsync` instead")
  func execute(_ closure: @escaping () -> Void)

  /// Calling this method will immediately execute a task, blocking the current thread until the task is
  /// finished. It needs to be reentrant (it can be called again from the closure argument without
  /// causing a deadlock).
  @discardableResult
  func executeSync<T>(_ closure: @escaping () -> T) -> T
}

extension Executor {
  /// Calling this method will enqueue a task to be executed asynchronously
  ///
  /// Note: this is the method that supersedes `execute(_:)`
  public func executeAsync(_ closure: @escaping () -> Void) {
    self.execute(closure)
  }

  /// Calling this method will immediately execute a task, blocking the current thread until the task is
  /// finished.
  ///
  /// Note: this default implementation will not use the underlying context for executing the closure. It
  /// will not use `executeAsync` under the hood, so you should not use this implementation if you need, for
  /// example, to execute the closure on a specific thread/queue.
  ///
  /// This is an default implementation made to avoid having a breaking change in the code. It
  /// will be removed in the future.
  @available(*, deprecated, message: "Use a proper primitive given by your underlying implementation")
  public func executeSync<T>(_ closure: @escaping () -> T) -> T {
    return closure()
  }
}

/// DispatchQueue conformance to `Executor` so that `DispatchQueue.main` can be used
extension DispatchQueue: Executor {
  public func execute(_ closure: @escaping () -> Void) {
    self.async(execute: closure)
  }

  public func executeSync<T>(_ closure: @escaping () -> T) -> T {
    // Since `DispatchQueue.sync` is not reentrant (it will just crash the app) a proper
    // check is needed. The idea is to use `.setSpecific` to add a value to the queue, and
    // then `.getSpecific` to get the value back. Note that `.getSpecific` does not operate
    // on `self`, but on the queue this thread is belonging to. This means that `.getSpecific`
    // will return the value set only if this function is executed in the queue (and therefore,
    // the closure must not be wrapped in a `self.sync`).

    let key = DispatchSpecificKey<Void>()
    self.setSpecific(key: key, value: ())
    defer {
      self.setSpecific(key: key, value: nil)
    }

    if DispatchQueue.getSpecific(key: key) != nil {
      return closure()
    } else {
      return self.sync(execute: closure)
    }
  }
}
