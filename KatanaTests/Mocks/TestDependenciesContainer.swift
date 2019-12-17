//
//  TestDependenciesContainer.swift
//  KatanaTests
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import Hydra

final class TestDependenciesContainer: SideEffectDependencyContainer {
  func delay(of interval: TimeInterval) -> Promise<Void> {
    return Promise<Void>({ resolve, reject, _ in
      DispatchQueue.global().asyncAfter(deadline: .now() + interval, execute: { resolve(()) })
    })
  }
  
  
  init(dispatch: @escaping SideEffectDependencyContainer.Dispatch, getState: @escaping GetState) {
    
  }
}
