//
//  ActionSyncReducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//


import Foundation

import Foundation
import XCTest
@testable import Katana

class ActionReducerTests: XCTestCase {
  func testSyncReducer() {
    let action = SyncActions.LogoutAction.with(payload: "Invalid token")
    let initialState = AuthenticationState(isAuthenticating: false, isAuthenticated: true, username: "username", token: "ABC")
    let newState = LogoutReducer.reduce(action: action, state: initialState)
    
    XCTAssertEqual(newState.isAuthenticating, false)
    XCTAssertEqual(newState.isAuthenticated, false)
    XCTAssertEqual(newState.username, nil)
    XCTAssertEqual(newState.token, nil)
  }
  
  
  func testAsyncReducerLoading() {
    let action = AsyncActions.LoginAction.with(payload: "")
    let initialState = AuthenticationState(isAuthenticating: false, isAuthenticated: false, username: nil, token: nil)
    let newState = LoginReducer.reduce(action: action, state: initialState)
    
    XCTAssertEqual(newState.isAuthenticating, true)
    XCTAssertEqual(newState.isAuthenticated, false)
    XCTAssertEqual(newState.username, nil)
    XCTAssertEqual(newState.token, nil)
  }
  
  func testAsyncReducerCompleted() {
    let username = "USERNAME"
    
    let action = AsyncActions.LoginAction.with(payload: "")
    let completedAction = action.completedAction(payload: username)
    let initialState = AuthenticationState(isAuthenticating: false, isAuthenticated: false, username: nil, token: nil)
    let newState = LoginReducer.reduce(action: completedAction, state: initialState)
    
    XCTAssertEqual(newState.isAuthenticating, false)
    XCTAssertEqual(newState.isAuthenticated, true)
    XCTAssertEqual(newState.username, username)
    XCTAssertEqual(newState.token?.isEmpty, false)
  }

  
  func testAsyncReducerError() {
    let action = AsyncActions.LoginAction.with(payload: "")
    let errorAction = action.errorAction(payload: "Invalid Password")
    let initialState = AuthenticationState(isAuthenticating: true, isAuthenticated: false, username: nil, token: nil)
    let newState = LoginReducer.reduce(action: errorAction, state: initialState)
    
    XCTAssertEqual(newState.isAuthenticating, false)
    XCTAssertEqual(newState.isAuthenticated, false)
    XCTAssertEqual(newState.username, nil)
    XCTAssertEqual(newState.token, nil)
  }
  
  func testCombinatedReducers() {
    let username = "username"
    
    // emulate the init action performed by the lib
    let initialState = AuthenticationReducer.reduce(action: InitAction(), state: nil)
    XCTAssertEqual(initialState, AuthenticationReducer.initialState)
    
    
    // simulate a login
    let loginActionLoading = AsyncActions.LoginAction.with(payload: username)
    let secondState = AuthenticationReducer.reduce(action: loginActionLoading, state: initialState)
    XCTAssertEqual(secondState.isAuthenticating, true)
    
    // simulate end login
    let loginActionDone = loginActionLoading.completedAction(payload: username)
    let thirdState = AuthenticationReducer.reduce(action: loginActionDone, state: secondState)
    XCTAssertEqual(thirdState.isAuthenticating, false)
    XCTAssertEqual(thirdState.isAuthenticated, true)
    XCTAssertEqual(thirdState.username, username)
    XCTAssertEqual(thirdState.token?.isEmpty, false)
    
    //simulate a logout
    let logoutAction = SyncActions.LogoutAction.with(payload: "")
    let fourthState = AuthenticationReducer.reduce(action: logoutAction, state: thirdState)
    XCTAssertEqual(fourthState.isAuthenticating, false)
    XCTAssertEqual(fourthState.isAuthenticated, false)
    XCTAssertEqual(fourthState.username, nil)
    XCTAssertEqual(fourthState.token, nil)
  }
}

