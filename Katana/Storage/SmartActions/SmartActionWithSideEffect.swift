//
//  SmartActionWithSideEffect.swift
//  Katana
//
//  Created by Luca Querella on 30/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnySmartActionWithSideEffect : Action {
  static func anySideEffect(action: Action, getState: StoreGetState<State>, dispatch: StoreDispatch)
}

public protocol SmartActionWithSideEffect: Action, AnySmartActionWithSideEffect {
  associatedtype StateType : State

  static func sideEffect(action: Self, getState: StoreGetState<StateType>, dispatch: StoreDispatch)
}

