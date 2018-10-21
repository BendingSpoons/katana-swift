//
//  SideEffect.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public protocol AnySideEffectContext {
  
}

public struct SideEffectContext<S, D> where S: State, D: SideEffectDependencyContainer {
  public let dependencies: D

  public func getState() -> S {
    fatalError()
  }
  
  public func dispatch(_ dispatchable: Dispatchable) -> Promise<Void> {
    fatalError()
  }
}

public protocol AnySideEffect: Dispatchable {
  func sideEffect(_ context: AnySideEffectContext) throws
}

public protocol SideEffect: AnySideEffect {
  associatedtype StateType: State
  associatedtype Dependencies: SideEffectDependencyContainer

  func sideEffect(_ context: SideEffectContext<StateType, Dependencies>) throws
}

public extension SideEffect {
  public func sideEffect(_ context: AnySideEffectContext) throws {
    guard let typedSideEffect = context as? SideEffectContext<StateType, Dependencies> else {
      fatalError("Invalid context pased to side effect")
    }
    
    try self.sideEffect(typedSideEffect)
  }
}
