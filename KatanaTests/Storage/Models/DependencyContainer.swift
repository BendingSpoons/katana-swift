//
//  DependencyContainer.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana

class SimpleDependencyContainer: SideEffectDependencyContainer {
  let state: AppState?

  public required init(state: State, dispatch: @escaping StoreDispatch) {
    if let s = state as? AppState {
      self.state = s

    } else {
      self.state = nil
    }
  }
}
