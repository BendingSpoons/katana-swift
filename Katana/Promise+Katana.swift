//
//  Promise+Katana.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra

/// Singleton container for the store
struct SharedStoreContainer {
  /// Share instance of the state, used to implement the Hydra helper methods
  /// - warning: Here we assume we have a single store for each app
  static var sharedStore: AnyStore!
}

/// Extension of the `Promise` object with some Katana related helpers
public extension Promise {
  
  /**
   This `then` allows to dispatch a `Dispatchable` that is used to get a chainable
   Promise.
   
   - parameter dispatchable: the dispatchable to dispatch
   - Returns: a chainable promise that will be resolved when the store will handle the dispatchable
  */
  @discardableResult
  func thenDispatch(_ dispatchable: Dispatchable) -> Promise<Void> {
    return self.then { _ in
      return SharedStoreContainer.sharedStore.dispatch(dispatchable)
    }
  }
  
  /**
   This `then`  allows to execute a block which return a `Dispatchable`; this value is used to get a chainable
   Promise. The block can also throw and invalidate the chain of Promise.
   
   - parameter body: a block that can either return a new `Dispatchable` or throw
   - Returns: a chainable promise that will be resolved when the store will handle the dispatchable
  */
  @discardableResult
  public func thenDispatch(_ body: @escaping ( (Value) throws -> Dispatchable) ) -> Promise<Void> {
    return self.then { value in
      let updater = try body(value)
      return SharedStoreContainer.sharedStore.dispatch(updater)
    }
  }
}

