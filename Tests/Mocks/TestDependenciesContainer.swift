//
//  TestDependenciesContainer.swift
//  Katana
//
//  Copyright © 2021 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra
import Katana

final class TestDependenciesContainer: SideEffectDependencyContainer {
  func delay(of interval: TimeInterval) -> Promise<Void> {
    return Promise<Void>({ resolve, _, _ in
      DispatchQueue.global().asyncAfter(deadline: .now() + interval) { resolve(()) }
    })
  }

  init(dispatch _: @escaping AnyDispatch, getState _: @escaping GetState) {}
}
