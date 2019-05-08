//
//  StoreTests.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import XCTest
@testable import Katana

class StoreTests: XCTestCase {
  func testInitialState() {
    let store = Store<AppState, SimpleDependencyContainer>()
    let state = store.state

    XCTAssertEqual(state.todo, TodoState())
    XCTAssertEqual(state.user, UserState())
  }

  func testDispatch() {
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

  #warning("restore")
//  func testDispatchWithinMiddleware() {
//    let expectation = self.expectation(description: "Store listener")
//    let middleware: StoreMiddleware = { getState, dispatch in
//      dispatch(AddTodoAction(title: "New Todo"))
//      return { next in
//        return { action in
//          next(action)
//          expectation.fulfill()
//        }
//      }
//    }
//
//    let store = Store<AppState, SimpleDependencyContainer>(
//      middleware: [middleware],
//      dependencies: EmptySideEffectDependencyContainer.self
//    )
//
//    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
//      let state = store.state
//      XCTAssertEqual(state.todo.todos.count, 1)
//      XCTAssertEqual(state.todo.todos[0].title, "New Todo")
//    }
//  }

  func testListener() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    let store = Store<AppState, SimpleDependencyContainer>()
    var newState: AppState? = nil

    _ = store.addListener { [unowned store] in
      count += 1
      if count == 2 {
        newState = store.state
        
        if #available(iOS 10.0, OSX 10.12, *) {
          dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
        }
        
        expectation.fulfill()
      }
    }

    store.dispatch(AddTodoAction(title: "New Todo"))

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(newState?.todo.todos.count, 1)
      XCTAssertEqual(newState?.todo.todos[0].title, "New Todo")
    }
  }

  func testListenerRemove() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")

    let store = Store<AppState, SimpleDependencyContainer>()
    var firstState: AppState? = nil
    var secondState: AppState? = nil
    var canFullfill: Bool = false

    // listener just to fullfill expectations
    _ = store.addListener {
      print(store.state)
      if canFullfill {
        expectation.fulfill()
      }
    }

    let unsubscribe = store.addListener { [unowned store] in
      count += 1
      if count > 1 {
        if firstState == nil {
          firstState = store.state
        } else {
          secondState = store.state
        }
      }
    }

    store.dispatch(AddTodoAction(title: "New Todo"))

    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
      unsubscribe()
      canFullfill = true
      store.dispatch(AddTodoAction(title: "Second Todo"))
    })

    self.waitForExpectations(timeout: 2) { (err: Error?) in
      // first callback invoked
      XCTAssertEqual(firstState?.todo.todos.count, 1)
      XCTAssertEqual(firstState?.todo.todos[0].title, "New Todo")

      // no second callback invoked
      XCTAssertNil(secondState)

      // state is ok
      let lastState = store.state
      let titles = lastState.todo.todos.map { $0.title }
      XCTAssertEqual(lastState.todo.todos.count, 2)
      XCTAssertEqual(titles.contains("New Todo"), true)
      XCTAssertEqual(titles.contains("Second Todo"), true)
    }
  }
}
