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
  public required init(dispatch: @escaping StoreDispatch) {}
}
