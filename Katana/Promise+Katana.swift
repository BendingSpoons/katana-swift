//
//  Promise+Katana.swift
//  Katana
//
//  Created by Mauro Bolis on 20/10/2018.
//

import Foundation

struct SharedStoreContainer {
  // note: here we assume we have a single store for each app
  // we should find a better way to handle this
  static var sharedStore: AnyStore!
}

public extension Promise {
  
  @discardableResult
  func thenDispatch(_ updater: AnyStateUpdater) -> Promise<Void> {
    return self.then { _ in
      return SharedStoreContainer.sharedStore.dispatch(updater)
    }
  }
  
  @discardableResult
  public func thenDispatch(_ body: @escaping ( (Value) throws -> AnyStateUpdater) ) -> Promise<Void> {
    return self.then { value in
      let updater = try body(value)
      return SharedStoreContainer.sharedStore.dispatch(updater)
    }
  }
}

