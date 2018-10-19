//
//  SideEffect.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

// lib

public struct SideEffectContext<S, D> where S: State, D: SideEffectDependencyContainer {
}

public protocol SideEffect {
  associatedtype StateType: State
  associatedtype Dependencies: SideEffectDependencyContainer

  func sideEffect(_ context: SideEffectContext<StateType, Dependencies>) throws
}
