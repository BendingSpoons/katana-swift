//
//  actionStates.swift
//  ReKatana
//
//  Created by Mauro Bolis on 11/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import ReKatana

struct AuthenticationState: State, Equatable {
  let isAuthenticating: Bool
  let isAuthenticated: Bool
  let username: String?
  let token: String?
  
  
  static func ==(lhs: AuthenticationState, rhs: AuthenticationState) -> Bool {
    return lhs.isAuthenticated == rhs.isAuthenticated &&
      lhs.isAuthenticated == rhs.isAuthenticated &&
      lhs.username == rhs.username &&
      lhs.token == rhs.token
  }
}
