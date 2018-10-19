//
//  Promise+Katana.swift
//  Katana
//
//  Created by Mauro Bolis on 19/10/2018.
//

import Foundation

enum SharedStoreContainer {
  static var sharedStore: AnyStore!
}

extension Promise {
  @discardableResult
  func thenDispatch(_ updater: AnyStateUpdater) -> Promise<Void> {
    return SharedStoreContainer.sharedStore.dispatch(updater)
  }
  
  @discardableResult
  public func thenDispatch(_ body: @escaping ( (Value) throws -> AnyStateUpdater) ) -> Promise<Void> {
    return self.then { value in
      let updater = try body(value)
      return SharedStoreContainer.sharedStore.dispatch(updater)
    }
  }
}
