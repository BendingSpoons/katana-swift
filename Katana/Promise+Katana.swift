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
  /// Shared instance of the state, used to implement the Hydra helper methods
  /// - warning: Here we assume we have a single store for each app
  static var sharedStore: AnyStore!
}

/// Extension of the `Promise` object with some Katana related helpers
public extension Promise {
  
  /**
   This `then` allows to dispatch a `StateUpdater` that is used to get a chainable
   Promise.
   
   - parameter dispatchable: the StateUpdater to dispatch
   - returns: a chainable promise that will be resolved when the store will handle the dispatchable
   */
  @discardableResult
  func thenDispatch(_ dispatchable: AnyStateUpdater) -> Promise<Void> {
    return self.then(in: .background) { _ in
      return dispatchable.callDispatch()
    }
  }
  
  /**
   This `then` allows to dispatch a `SideEffect` that is used to get a chainable
   Promise parameterized by the SideEffect with a return value.
   
   - parameter dispatchable: the SideEffect to dispatch
   - returns: a parameterized chainable promise that will be resolved when the store will handle the dispatchable
   */
  @discardableResult
  func thenDispatch<SE: SideEffect>(_ dispatchable: SE) -> Promise<SE.ReturnValue> {
    return self.then(in: .background) { _ in
      return dispatchable.callDispatch()
    }
  }
  
  /**
   This `then`  allows to execute a block which return a `StateUpdater`; this value is used to get a chainable
   Promise. The block can also throw and invalidate the chain of Promise.
   
   - parameter body: a block that can either return a new `StateUpdater` or throw
   - returns: a chainable promise that will be resolved when the store will handle the dispatchable
   */
  @discardableResult
  func thenDispatch(_ body: @escaping ( (Value) throws -> AnyStateUpdater) ) -> Promise<Void> {
    return self.then { value in
      let updater = try body(value)
      return updater.callDispatch()
    }
  }
  
  /**
   This `then`  allows to execute a block which return a `SideEffect`; this value is used to get a chainable
   Promise. The block can also throw and invalidate the chain of Promise.
   
   - parameter body: a block that can either return a new `SideEffect` or throw
   - returns: a parameterized chainable promise that will be resolved when the store will handle the dispatchable
   */
  @discardableResult
  func thenDispatch<SE: SideEffect>(_ body: @escaping ( (Value) throws -> SE) ) -> Promise<SE.ReturnValue> {
    return self.then { value in
      let sideEffect = try body(value)
      return sideEffect.callDispatch()
    }
  }
}

fileprivate extension SideEffect {
  func callDispatch() -> Promise<Self.ReturnValue> {
    // https://open.spotify.com/album/2cbbIQk2gIP2nlK0QGI7Nm
    // https://stackoverflow.com/questions/33112559/protocol-doesnt-conform-to-itself/43408193#43408193
    return SharedStoreContainer.sharedStore.dispatch(self)
  }
}

fileprivate extension AnyStateUpdater {
  func callDispatch() -> Promise<Void> {
    // https://open.spotify.com/album/2cbbIQk2gIP2nlK0QGI7Nm
    // https://stackoverflow.com/questions/33112559/protocol-doesnt-conform-to-itself/43408193#43408193
    return SharedStoreContainer.sharedStore.dispatch(self)
  }
}

