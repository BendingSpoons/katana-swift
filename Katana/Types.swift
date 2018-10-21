//
//  StoreTypealiases.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public protocol Dispatchable {}

///// Typealias for a `Store` listener
//public typealias StoreListener = () -> ()
//
///// Typealias for the `Store` listener unsubscribe closure
//public typealias StoreUnsubscribe = () -> ()
//
///**
// Typealias for the `Store` middleware. Note that the first part of the middleware
// (the one with `getState` and `dispatch`) is immediately invoked when the store is created
// */
//public typealias StoreMiddleware =
//  (_ getState: @escaping () -> State, _ dispatch: @escaping StoreDispatch) ->
//  (_ next: @escaping StoreDispatch) ->
//  (_ action: Action) -> ()

/// Typealias for the `Store` dispatch function
public typealias StoreDispatch = (_: Dispatchable) -> Promise<Void>
