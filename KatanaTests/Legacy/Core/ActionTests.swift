//
//  ActionTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import XCTest
import Quick
import Nimble

class ActionTests: XCTestCase {
  func testSyncAction() {
    let expectation = self.expectation(description: "Store listener")

    let store = Store<AppState>()
    _ = store.addListener { expectation.fulfill() }
    store.dispatch(AddTodoAction(title: "New Todo"))

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state

      XCTAssertEqual(newState.todo.todos.count, 1)
      XCTAssertEqual(newState.todo.todos[0].title, "New Todo")
    }
  }
}
