//
//  StoreTypealiases.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// Typealias for a `Store` listener
public typealias StoreListener = () -> ()

/// Typealias for the `Store` listener unsubscribe closure
public typealias StoreUnsubscribe = () -> ()

/// Typealias for the `Store` middleware
public typealias StoreMiddleware<StateType: State> =
  (_ getState: @escaping () -> StateType, _ dispatch: @escaping StoreDispatch) ->
    (_ next: @escaping StoreDispatch) ->
      (_ action: AnyAction) -> ()

/// Typealias for the `Store` dispatch function
public typealias StoreDispatch = (_: AnyAction) -> ()
