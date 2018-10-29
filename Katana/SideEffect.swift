//
//  SideEffect.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public protocol AnySideEffectContext {
  var getAnyState: () -> State { get }
  var dispatch: PromisableStoreDispatch { get }
  var anyDependencies: SideEffectDependencyContainer { get }
}

public struct SideEffectContext<S, D> where S: State, D: SideEffectDependencyContainer {
  public let dependencies: D
  public let getState: () -> S
  public let dispatch: PromisableStoreDispatch
  
  init(dependencies: D, getState: @escaping () -> S, dispatch: @escaping PromisableStoreDispatch) {
    self.dependencies = dependencies
    self.dispatch = dispatch
    self.getState = getState
  }
}

public extension AnySideEffectContext {
  func awaitDispatch(_ dispatchable: Dispatchable) throws {
    try await(self.dispatch(dispatchable))
  }
}

extension SideEffectContext: AnySideEffectContext {
  public var getAnyState: () -> State {
    return self.getState
  }
  
  public var anyDependencies: SideEffectDependencyContainer {
    return self.dependencies
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
