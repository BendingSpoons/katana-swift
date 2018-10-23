//
//  StoreTypealiases.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/** 
 Typealias for the `Store` middleware. Note that the first part of the middleware
 (the one with `getState` and `dispatch`) is immediately invoked when the store is created
*/
public typealias StoreMiddleware =
  (_ getState: @escaping () -> State, _ dispatch: @escaping StoreDispatch) ->
    (_ next: @escaping StoreDispatch) ->
      (_ action: Action) -> ()

/// Typealias for the `Store` dispatch function
public typealias StoreDispatch = (_: Action) -> ()

#warning("implement")
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
