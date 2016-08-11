//
//  actionReducers.swift
//  ReKatana
//
//  Created by Mauro Bolis on 11/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import ReKatana

enum LogoutReducer: SyncReducer {
  static func reduceSync(action: SyncActions.LogoutActionType, state: AuthenticationState) -> AuthenticationState {
    return AuthenticationState(isAuthenticating: false, isAuthenticated: false, username: nil, token: nil)
  }
}

enum LoginReducer: AsyncReducer {
  static func reduceLoading(action: AsyncActions.LoginActionType, state: AuthenticationState) -> AuthenticationState {
    return AuthenticationState(isAuthenticating: true, isAuthenticated: false, username: nil, token: nil)
  }
  
  static func reduceCompleted(action: AsyncActions.LoginActionType, state: AuthenticationState) -> AuthenticationState {
    let token = NSUUID().uuidString
    let username = action.completedPayload
    return AuthenticationState(isAuthenticating: false, isAuthenticated: true, username: username, token: token)
  }
  
  static func reduceError(action: AsyncActions.LoginActionType, state: AuthenticationState) -> AuthenticationState {
    return AuthenticationState(isAuthenticating: false, isAuthenticated: false, username: nil, token: nil)
  }
}


enum AuthenticationReducer: ReducerCombiner {
  typealias StateType = AuthenticationState
  static let initialState = AuthenticationState(isAuthenticating: false, isAuthenticated: false, username: nil, token: nil)
  
  static var reducers: [String : AnyReducer.Type] = [
    AsyncActions.LoginAction.actionName: LoginReducer.self,
    SyncActions.LogoutAction.actionName: LogoutReducer.self
  ]
}
