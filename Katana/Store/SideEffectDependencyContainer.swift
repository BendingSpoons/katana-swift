//
//  SideEffectDependencyContainer.swift
//  Katana
//
//  Created by Mauro Bolis on 29/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol SideEffectDependencyContainer {
  init(state: State, dispatch: @escaping StoreDispatch)
}

public struct EmptySideEffectDependencyContainer: SideEffectDependencyContainer {
  public init(state: State, dispatch: @escaping StoreDispatch) {}
}
