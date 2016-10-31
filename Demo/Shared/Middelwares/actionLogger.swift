//
//  actionLogger.swift
//  Katana
//
//  Created by Luca Querella on 02/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

public func actionLoggerMiddleware<S: State>(_ type: S.Type) -> StoreMiddleware<S> {
  return { state, dispatch in
    return { next in
      return { action in
        print(action)
        next(action)
      }
    }
  }
}
