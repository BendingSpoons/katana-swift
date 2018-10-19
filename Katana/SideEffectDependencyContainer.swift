//
//  SideEffectDependencyContainer.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// Protocol that the side effect dependencies container should implement
public protocol SideEffectDependencyContainer: class {
  /**
   Creates a new instance of the container.
   The container is instantiated when the store is instantiated
   
   - parameter dispatch:  a closure that can be used to dispatch actions
   - parameter getState:  a closure that returns the current state
   - returns: an instance of the container
   */
  #warning("restore")
//  init(dispatch: @escaping StoreDispatch, getState: @escaping () -> State)
}

/// An empty dependencies container. It can be used for testing purposes or you don't need dependencies
public class EmptySideEffectDependencyContainer: SideEffectDependencyContainer {
  /**
   Creates an empty dependency container
   
   - parameter dispatch:  a closure that can be used to dispatch actions
   - returns: an instance of the container
   */
  #warning("restore")
//  public required init(dispatch: @escaping StoreDispatch, getState: @escaping () -> State) {}
}
