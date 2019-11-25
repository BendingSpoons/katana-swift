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
   - returns: a chainable promise that will be resolved when the store will handle the dispatchable
  */
  @discardableResult
  func thenDispatch(_ dispatchable: Dispatchable) -> Promise<Void> {
    return self.then(in: .background) { _ in
//      return dispatchable.callDispatch()
      fatalError()
    }
  }
  
  /**
   This `then`  allows to execute a block which return a `Dispatchable`; this value is used to get a chainable
   Promise. The block can also throw and invalidate the chain of Promise.
   
   - parameter body: a block that can either return a new `Dispatchable` or throw
   - returns: a chainable promise that will be resolved when the store will handle the dispatchable
  */
  @discardableResult
  func thenDispatch(_ body: @escaping ( (Value) throws -> Dispatchable) ) -> Promise<Void> {
    return self.then { value in
      fatalError()
//      let updater = try body(value)
//      return updater.callDispatch()
    }
  }
}

extension Dispatchable {
  func callDispatch() -> Promise<Void> {
    // https://open.spotify.com/album/2cbbIQk2gIP2nlK0QGI7Nm
    // https://stackoverflow.com/questions/33112559/protocol-doesnt-conform-to-itself/43408193#43408193
    fatalError()
    return SharedStoreContainer.sharedStore.dispatch(self)
  }
}

