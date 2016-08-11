//
//  AsyncActionTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
import XCTest
@testable import ReKatana

class AsyncActionTests: XCTestCase {
  func testActionCreation() {
    let action = AsyncActions.LoginAction.with(payload: "token")

    XCTAssertEqual(AsyncActions.LoginAction.actionName, "LoginAction")
    XCTAssertEqual(action.actionName, AsyncActions.LoginAction.actionName)
    XCTAssertEqual(action.payload, "token")
    XCTAssertEqual(action.completedPayload, nil)
    XCTAssertEqual(action.errorPayload, nil)
    XCTAssertEqual(action.state, AsyncActionState.Loading)
  }
  
  func testActionCompleted() {
    let username = "username"
    let action = AsyncActions.LoginAction.with(payload: "token")
    let completedAction = action.completedAction(payload: username)
    
    XCTAssertEqual(completedAction.actionName, AsyncActions.LoginAction.actionName)
    XCTAssertEqual(completedAction.payload, nil)
    XCTAssertEqual(completedAction.completedPayload, username)
    XCTAssertEqual(completedAction.errorPayload, nil)
    XCTAssertEqual(completedAction.state, AsyncActionState.Completed)
  }

  func testActionError() {
    let error = "error"
    let action = AsyncActions.LoginAction.with(payload: "token")
    let errorAction = action.errorAction(payload: error)
    
    XCTAssertEqual(errorAction.actionName, AsyncActions.LoginAction.actionName)
    XCTAssertEqual(errorAction.payload, nil)
    XCTAssertEqual(errorAction.completedPayload, nil)
    XCTAssertEqual(errorAction.errorPayload, error)
    XCTAssertEqual(errorAction.state, AsyncActionState.Error)
  }
}

