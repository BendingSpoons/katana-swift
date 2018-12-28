//
//  StoreTypealiases.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

public typealias StoreMiddlewareNext = (_: Dispatchable) -> Void

/**
 Typealias for the `Store` middleware. Note that the first part of the middleware
 (the one with `getState` and `dispatch`) is immediately invoked when the store is created
 */
@available(*, deprecated, message: "Use StoreInterceptor instead")
public typealias StoreMiddleware =
  (_ getState: @escaping () -> State, _ dispatch: @escaping StoreDispatch) ->
  (_ next: @escaping StoreMiddlewareNext) ->
  (_ dispatchable: Dispatchable) -> ()

/// Typealias for the `Store` dispatch function
@available(*, deprecated, message: "Use PromisableStoreDispatch instead")
public typealias StoreDispatch = (_: Action) -> ()

/**
 Helper function that transforms a (deprecated) middleware into a logically equivalent
 interceptor. This method can be used to keep old middleware working on the new Katana.
 
 - parameter middleware: the middleware to transform
 - returns: a logically equivalent interceptor
*/
public func middlewareToInterceptor(_ middleware: @escaping StoreMiddleware) -> StoreInterceptor {
  return { context in
    
    let legacyDispatch: StoreDispatch = { dispatchable in
      let _ = context.dispatch(dispatchable)
    }
    
    let initialisedMiddleware = middleware(context.getAnyState, legacyDispatch)
    
    return { next in
      var sideEffectError: Error?
      let legacyNext: StoreMiddlewareNext = { action in
        do {
          try next(action)
        } catch {
          // legacy next cannot throw
          sideEffectError = error
        }
      }
      
      return { dispatchable in
        initialisedMiddleware(legacyNext)(dispatchable)
        // If an error occurred, throw to reject the dispatch Promise
        if let error = sideEffectError { throw error }
      }
    }
  }
}
