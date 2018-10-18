//
//  SideEffect.swift
//  Katana
//
//  Created by Mauro Bolis on 18/10/2018.
//

import Foundation

// lib

public struct SideEffectContext<S, D> where S: State, D: SideEffectDependencyContainer {
}

public protocol SideEffect {
  associatedtype StateType: State
  associatedtype Dependencies: SideEffectDependencyContainer

  func sideEffect(_ context: SideEffectContext<StateType, Dependencies>) throws
}
