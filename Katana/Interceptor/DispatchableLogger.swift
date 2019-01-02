//
//  DispatchableLogger.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// Interceptor that logs all the dispatched items in the XCode console.
public struct DispatchableLogger {
  
  /**
   This function returns a `StoreInterceptor` that intercepts and logs not black-listed actions
   
   - parameter blackList: list of dispatchable types that must not be logged
   - returns: store interceptor that logs not black-listed actions
   - seeAlso: `StoreInterceptor` for details
   */
  public static func interceptor(blackList: [Dispatchable.Type] = []) -> StoreInterceptor {
    return { context in
      return { next in
        return { dispatchable in

          try next(dispatchable)

          DispatchQueue.global(qos: .utility).async {
            let actionType = type(of: dispatchable) as Dispatchable.Type
            guard !blackList.contains(where: { $0 == actionType }) else { return }
            print("[Dispatchable]: \(dispatchable.debugDescription)")
          }
        }
      }
    }
  }
}
