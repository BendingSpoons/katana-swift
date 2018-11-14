//
//  TestDependenciesContainer.swift
//  KatanaTests
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana

final class TestDependenciesContainer: SideEffectDependencyContainer {
  
  
  func delay(of interval: TimeInterval) -> Promise<Void> {
    return Promise { resolve, reject, _ in
      DispatchQueue.global().asyncAfter(deadline: .now() + interval, execute: resolve)
    }
  }
  
  
  init(dispatch: @escaping PromisableStoreDispatch, getState: @escaping GetState) {
    
  }
}
