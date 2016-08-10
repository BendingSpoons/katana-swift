//
//  SyncActionTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
import XCTest
@testable import ReKatana

class SyncActionTests: XCTestCase {
  func testActionCreation() {
    let TestAction = SyncActionCreator<(u: String, p: String)>(withName: "TestAction")
    let action = TestAction.with(payload: (u: "username", p: "password"))
    
    XCTAssertEqual(TestAction.actionName, "TestAction")
    XCTAssertEqual(action.actionName, "TestAction")
    XCTAssertEqual(action.payload?.u, "username")
    XCTAssertEqual(action.payload?.p, "password")
  }
}
