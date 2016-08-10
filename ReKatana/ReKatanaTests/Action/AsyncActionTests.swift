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
    let TestAction = AsyncActionCreator<(u: String, p: String), Int, Float>(withName: "TestAction")
    let action = TestAction.with(payload: (u: "username", p: "password"))
    
    XCTAssertEqual(TestAction.actionName, "TestAction")
    XCTAssertEqual(action.actionName, "TestAction")
    XCTAssertEqual(action.payload?.u, "username")
    XCTAssertEqual(action.payload?.p, "password")
    XCTAssertEqual(action.completedPayload, nil)
    XCTAssertEqual(action.errorPayload, nil)
    XCTAssertEqual(action.state, AsyncActionState.Loading)
  }
  
  func testActionCompleted() {
    let TestAction = AsyncActionCreator<String, Int, Float>(withName: "TestAction")
    let action = TestAction.with(payload: "PAYLOAD")
    let completedAction = action.completedAction(payload: 1)
    
    XCTAssertEqual(completedAction.actionName, "TestAction")
    XCTAssertEqual(completedAction.payload, nil)
    XCTAssertEqual(completedAction.completedPayload, 1)
    XCTAssertEqual(completedAction.errorPayload, nil)
    XCTAssertEqual(completedAction.state, AsyncActionState.Completed)
  }

  func testActionError() {
    let TestAction = AsyncActionCreator<String, Int, Float>(withName: "TestAction")
    let action = TestAction.with(payload: "PAYLOAD")
    let errorAction = action.errorAction(payload: 0.05)
    
    XCTAssertEqual(errorAction.actionName, "TestAction")
    XCTAssertEqual(errorAction.payload, nil)
    XCTAssertEqual(errorAction.completedPayload, nil)
    XCTAssertEqual(errorAction.errorPayload, 0.05)
    XCTAssertEqual(errorAction.state, AsyncActionState.Error)
  }
}

