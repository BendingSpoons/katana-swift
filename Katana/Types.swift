//
//  StoreTypealiases.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public protocol Dispatchable {}

/// Typealias for a `Store` listener
public typealias StoreListener = () -> ()

/// Typealias for the `Store` listener unsubscribe closure
public typealias StoreUnsubscribe = () -> ()

#warning("use real protocol, this is a temporary fix")
public protocol Action: Dispatchable {}

/**
 Typealias for the `Store` middleware. Note that the first part of the middleware
 (the one with `getState` and `dispatch`) is immediately invoked when the store is created
 */
#warning("move in legacy")
public typealias StoreMiddleware =
  (_ getState: @escaping () -> State, _ dispatch: @escaping StoreDispatch) ->
  (_ next: @escaping StoreDispatch) ->
  (_ action: Action) -> ()


public typealias StoreInterceptorNext = (_: Dispatchable) throws -> Void
public typealias GetState = () -> State

public typealias StoreInterceptor =
  (_ getState: @escaping GetState, _ dispatch: @escaping PromisableStoreDispatch) ->
  (_ next: @escaping StoreInterceptorNext) ->
  (_ dispatchable: Dispatchable) throws -> ()

/// Typealias for the `Store` dispatch function with the ability of managing the output with a promise
public typealias PromisableStoreDispatch = (_: Dispatchable) -> Promise<Void>

/// Typealias for the `Store` dispatch function
#warning("move in legacy")
public typealias StoreDispatch = (_: Action) -> Void

public struct StoreInterceptorChainBlocked: Error {
}

//public func convertMiddlewareToInterceptor(_ middleware: @escaping StoreMiddleware) -> StoreInterceptor {
//  return { getState, dispatch in
//
//    let legacyDispatch: StoreDispatch = { dispatchable in
//      let _ = dispatch(dispatchable)
//    }
//
//    let p = middleware(getState, legacyDispatch)
//
//    return { next in
//
//      let legacyNext: StoreDispatch = { nextiii in
//        let _ = next(nextiii)
//      }
//
//      let n = p(legacyNext)
//
//      return { action in
//        #warning("complete & improve this")
////        n(action)
//      }
//    }
//  }
//}
