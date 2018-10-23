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

public typealias StoreInterceptorNext = (_: Dispatchable) throws -> Void
public typealias GetState = () -> State

public typealias StoreInterceptor =
  (_ getState: @escaping GetState, _ dispatch: @escaping PromisableStoreDispatch) ->
  (_ next: @escaping StoreInterceptorNext) ->
  (_ dispatchable: Dispatchable) throws -> ()

/// Typealias for the `Store` dispatch function with the ability of managing the output with a promise
public typealias PromisableStoreDispatch = (_: Dispatchable) -> Promise<Void>

public struct StoreInterceptorChainBlocked: Error {}
