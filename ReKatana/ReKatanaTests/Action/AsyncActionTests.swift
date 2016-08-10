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
    let action = AsyncActions.LoginAction.with(payload: "token")
    let completedAction = action.completedAction(payload: 1)
    
    XCTAssertEqual(completedAction.actionName, AsyncActions.LoginAction.actionName)
    XCTAssertEqual(completedAction.payload, nil)
    XCTAssertEqual(completedAction.completedPayload, 1)
    XCTAssertEqual(completedAction.errorPayload, nil)
    XCTAssertEqual(completedAction.state, AsyncActionState.Completed)
  }

  func testActionError() {
    let action = AsyncActions.LoginAction.with(payload: "token")
    let errorAction = action.errorAction(payload: 0.05)
    
    XCTAssertEqual(errorAction.actionName, AsyncActions.LoginAction.actionName)
    XCTAssertEqual(errorAction.payload, nil)
    XCTAssertEqual(errorAction.completedPayload, nil)
    XCTAssertEqual(errorAction.errorPayload, 0.05)
    XCTAssertEqual(errorAction.state, AsyncActionState.Error)
  }
}

