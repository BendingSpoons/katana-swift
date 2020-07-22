//
//  Types.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra

/**
 Typealias for the function that is invoked to continues with the middleware
 chains.
 */
public typealias StoreListener = () -> ()

/// Typealias for the `Store` listener unsubscribe closure
public typealias StoreUnsubscribe = () -> ()

/// Typealias for a type that returns the `Store`'s state
public typealias GetState = () -> State

/// Typealias for the `Store.anyDispatch` function with the ability of managing the output with a promise
public typealias AnyDispatch = (_: Dispatchable) -> Promise<Any>

/// Entity capable of executing task asynchronously. This can be useful in tests to control asyncrhonous tasks
public protocol AsyncProvider {
  /// Calling this method will enqueue a closure to be executed asynchronously
  func execute(_ closure: @escaping () -> Void)
}

/// DispatchQueue conformance to `AsyncProvider` so that `DispatchQueue.main` can be used
extension DispatchQueue: AsyncProvider {
  public func execute(_ closure: @escaping () -> Void) {
    self.async(execute: closure)
  }
}
