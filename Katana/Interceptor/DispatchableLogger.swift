//
//  DispatchableLogger.swift
//  Katana
//
//  Copyright © 2018 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.
//

import Foundation

/**
 Struct that makes an action logger middleware available
 */
@available(*, deprecated, message: "Use ObserverInterceptor instead")
public struct DispatchableLogger {
  
  /**
   This function returns a `StoreInterceptor` that intercepts and logs not black-listed actions
   
   - Parameters:
   - blackList: list of dispatchable types that must not be logged
   - Returns: store interceptor that logs not black-listed actions
   - See: `StoreInterceptor` for details
   */
  public static func interceptor(blackList: [Dispatchable.Type] = []) -> StoreInterceptor {
    
    return { getState, dispatch in
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
