//
//  ActionTests.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import XCTest

class LegacyActionTests: XCTestCase {
  func testSyncAction() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")

    let store = Store<AppState, SimpleDependencyContainer>()
    _ = store.addListener {
      count += 1
      if count == 2 {
        expectation.fulfill()
      }
    }
    store.dispatch(AddTodoAction(title: "New Todo"))

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state

      XCTAssertEqual(newState.todo.todos.count, 1)
      XCTAssertEqual(newState.todo.todos[0].title, "New Todo")
    }
  }
}
