//
//  SideEffectDependencyContainer.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra

/// Protocol that the side effect dependencies container should implement
public protocol SideEffectDependencyContainer: class {
  /**
   Creates a new instance of the container.
   The container is instantiated when the store is instantiated
   
   - parameter dispatch:  a closure that can be used to dispatch dispatchables
   - parameter getState:  a closure that returns the current state
   - returns: an instance of the container
   */
  init(dispatch: @escaping AnyDispatch, getState: @escaping GetState)
}

/// An empty dependencies container. It can be used for testing purposes or you don't need dependencies
public class EmptySideEffectDependencyContainer: SideEffectDependencyContainer {
  /**
   Creates an empty dependency container
   
   - parameter dispatch:  a closure that can be used to dispatch dispatchables
   - returns: an instance of the container
   */
  public required init(dispatch: @escaping AnyDispatch, getState: @escaping GetState) {}
}
