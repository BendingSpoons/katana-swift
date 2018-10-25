//
//  Promise+Katana.swift
//  Katana
//
//  Copyright © 2018 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.
//

import Foundation

struct SharedStoreContainer {
  // note: here we assume we have a single store for each app
  // we should find a better way to handle this
  static var sharedStore: AnyStore!
}

public extension Promise {
  
  @discardableResult
  func thenDispatch(_ updater: Dispatchable) -> Promise<Void> {
    return self.then { _ in
      return SharedStoreContainer.sharedStore.dispatch(updater)
    }
  }
  
  @discardableResult
  public func thenDispatch(_ body: @escaping ( (Value) throws -> Dispatchable) ) -> Promise<Void> {
    return self.then { value in
      let updater = try body(value)
      return SharedStoreContainer.sharedStore.dispatch(updater)
    }
  }
}

