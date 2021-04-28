//
//  StateUpdaterTests.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.
//

import Foundation
import XCTest

@testable import Katana

class StateUpdaterTests: XCTestCase {
  func testDispatch_invokesTheStateUpdater() {
    let todo = Todo(title: "test", id: "ABC")
    let store = Store<AppState, TestDependenciesContainer>()

    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testDispatch_whenChained_areInvokedInOrder() {
    let todo = Todo(title: "test", id: "ABC")
    let user = User(username: "the_username")

    let store = Store<AppState, TestDependenciesContainer>()

    self.waitForPromise(
      store
        .dispatch(AddTodo(todo: todo))
        .then {
          XCTAssertEqual(store.state.todo.todos, [todo])
          XCTAssertTrue(store.state.user.users.isEmpty)
        }
        .then { store.dispatch(AddUser(user: user)) }
        .then {
          XCTAssertEqual(store.state.todo.todos, [todo])
          XCTAssertEqual(store.state.user.users, [user])
        }
    )
  }

  func testDispatch_whenNotChained_areInvokedInOrder() {
    let todo1 = Todo(title: "test", id: "ABC")
    let todo2 = Todo(title: "test1", id: "DEF")
    let todo3 = Todo(title: "test2", id: "GHI")

    let store = Store<AppState, TestDependenciesContainer>()

    let promise1 = store.dispatch(AddTodoWithDelay(todo: todo1, waitingTime: 3))
    let promise2 = store.dispatch(AddTodoWithDelay(todo: todo2, waitingTime: 2))
    let promise3 = store.dispatch(AddTodoWithDelay(todo: todo3, waitingTime: 0))
    self.waitForPromises(promise1, promise2, promise3)

    XCTAssertEqual(store.state.todo.todos, [todo1, todo2, todo3])
  }
}

private struct AddTodoWithDelay: TestStateUpdater {
  let todo: Todo
  let waitingTime: TimeInterval

  func updateState(_ state: inout AppState) {
    // Note: this is just for testing, never do things like this in real apps
    Thread.sleep(forTimeInterval: self.waitingTime)
    state.todo.todos.append(self.todo)
  }
}
