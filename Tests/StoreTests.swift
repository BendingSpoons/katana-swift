//
//  StoreTests.swift
//  Katana
//
//  Copyright © 2021 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import XCTest

@testable import Katana

class StoreTest: XCTestCase {
  func testDefaultInit_initializesEmptyState() {
    let store = Store<AppState, TestDependenciesContainer>()
    self.waitFor { store.isReady }
    XCTAssertEqual(store.state, AppState())
  }

  func testListeners_areInvokedOnStateChange() {
    var listenerState: AppState?

    let todo = Todo(title: "title", id: "id")
    let store = Store<AppState, TestDependenciesContainer>()
    _ = store.addListener {
      listenerState = store.state
    }
    store.dispatch(AddTodo(todo: todo)).then {
      XCTAssertEqual(listenerState?.todo.todos, [todo])
    }
  }

  func testUnsubscribeListeners_areInvokedOnStateChange() {
    var listenerState: AppState?

    let todo = Todo(title: "title", id: "id")
    let store = Store<AppState, TestDependenciesContainer>()
    let unsubscribe = store.addListener {
      listenerState = store.state
    }
    store
      .dispatch(AddTodo(todo: todo))
      .then {
        XCTAssertEqual(listenerState?.todo.todos, [todo])
        unsubscribe()
      }
      .then { store.dispatch(AddTodo(todo: todo)) }
      .then {
        XCTAssertEqual(listenerState?.todo.todos, [todo])
        unsubscribe()
      }
  }
}
