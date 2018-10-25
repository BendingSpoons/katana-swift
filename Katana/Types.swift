//
//  Types.swift
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

public typealias GetState = () -> State

/// Typealias for the `Store` dispatch function with the ability of managing the output with a promise
public typealias PromisableStoreDispatch = (_: Dispatchable) -> Promise<Void>
