//
//  Typealiases.swift
//  Katana
//
//  Created by Mauro Bolis on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/// Typealias for a `Store` listener
public typealias StoreListener = () -> Void

/// Typealias for the `Store` listener unsubscribe closure
public typealias StoreUnsubscribe = () -> ()

/// Typealias for the `Store` middlewares
public typealias StoreMiddleware<StateType: State> =
  (_ getState: @escaping () -> StateType, _ dispatch: @escaping StoreDispatch) ->
    (_ next: @escaping StoreDispatch) ->
      (_ action: AnyAction) -> Void

/// Typealias for the `Store` dispatch function
public typealias StoreDispatch = (_: AnyAction) -> Void
