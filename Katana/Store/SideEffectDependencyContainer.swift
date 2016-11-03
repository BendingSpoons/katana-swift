//
//  SideEffectDependencyContainer.swift
//  Katana
//
//  Created by Mauro Bolis on 29/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/**
 Protocol that the side effect dependencies container should implement
*/
public protocol SideEffectDependencyContainer {
  /**
   Creates a new instance of the container.
   A new container is created every time a side effect is invoked
   
   - parameter state:     the current state
   - parameter dispatch:  a closure that can be used to dispatch actions
   - returns: an instance of the container
  */
  init(state: State, dispatch: @escaping StoreDispatch)
}

/// An empty dependencies container. It can be used for testing purposes or you don't need dependencies
public struct EmptySideEffectDependencyContainer: SideEffectDependencyContainer {
  /**
   Creates the empty dependency container
   
   - parameter state:     the current state
   - parameter dispatch:  a closure that can be used to dispatch actions
   - returns: an instance of the container
  */
  public init(state: State, dispatch: @escaping StoreDispatch) {}
}
