//
//  SyncActionTests.swift
//  Katana
//
//  Created by Mauro Bolis on 28/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import XCTest

class SyncActionTests: XCTestCase {
  func testSyncAction() {
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<AppState>()
    _ = store.addListener { expectation.fulfill() }
    store.dispatch(SyncAddTodoAction(payload: "New Todo"))
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      
      XCTAssertEqual(newState.todo.todos.count, 1)
      XCTAssertEqual(newState.todo.todos[0].title, "New Todo")
    }
  }
}
