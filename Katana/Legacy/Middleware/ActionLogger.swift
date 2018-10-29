//
//  ActionLogger.swift
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
@available(*, deprecated, message: "Use DispatchableLogger instead")
public struct ActionLogger {
  
  /**
   This function returns a `StoreMiddleware` that intercepts and logs not black-listed actions
   
   - Parameters:
       - blackList: list of action types that must not be logged
   - Returns: store middleware that logs not black-listed actions
   - See: `StoreMiddleware` for details
   */
  public static func middleware(blackList: [Action.Type] = []) -> StoreMiddleware {
  
    return { getState, dispatch in
      return { next in
        return { action in
          
          next(action)
          
          DispatchQueue.global(qos: .utility).async {
            let actionType = type(of: action) as Dispatchable.Type
            guard !blackList.contains(where: { $0 == actionType }) else { return }
            print("[Action]: \(action.debugDescription)")
          }
        }
      }
    }
  }
}
