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
    let action = SyncActions.LogoutAction.with(payload: "Invalid Token")
    
    XCTAssertEqual(SyncActions.LogoutAction.actionName, "LogoutAction")
    XCTAssertEqual(action.actionName, SyncActions.LogoutAction.actionName)
    XCTAssertEqual(action.payload, "Invalid Token")
  }
}
