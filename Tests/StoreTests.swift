//
//  StoreTests.swift
//  Katana
//
//  Copyright © 2021 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra
import XCTest

@testable import Katana

class StoreTest: XCTestCase {
  func testDefaultInit_initializesEmptyState() {
    let store = Store<AppState, TestDependenciesContainer>()
    self.waitFor { store.isReady }
    XCTAssertEqual(store.state, AppState())
  }

  func testListeners_areInvokedOnStateChange() {
    var listenerOldState: AppState?
    var listenerNewState: AppState?

    let todo = Todo(title: "title", id: "id")
    let store = Store<AppState, TestDependenciesContainer>()
    _ = store.addListener { oldState, newState in
      listenerOldState = oldState
      listenerNewState = newState
    }
    self.waitForPromise(
      store.dispatch(AddTodo(todo: todo)).then {
        XCTAssertEqual(listenerOldState?.todo.todos, [])
        XCTAssertEqual(listenerNewState?.todo.todos, [todo])
      }
    )
  }

  func testUnsubscribeListeners_areInvokedOnStateChange() {
    var listenerOldState: AppState?
    var listenerNewState: AppState?

    let todo = Todo(title: "title", id: "id")
    let store = Store<AppState, TestDependenciesContainer>()
    let unsubscribe = store.addListener { oldState, newState in
      listenerOldState = oldState
      listenerNewState = newState
    }
    store
      .dispatch(AddTodo(todo: todo))
      .then {
        XCTAssertEqual(listenerOldState?.todo.todos, [])
        XCTAssertEqual(listenerNewState?.todo.todos, [todo])
        unsubscribe()
      }
      .then { store.dispatch(AddTodo(todo: todo)) }
      .then {
        XCTAssertEqual(listenerOldState?.todo.todos, [])
        XCTAssertEqual(listenerNewState?.todo.todos, [todo])
      }
  }

  func testStoreListener_whenMultipleConcurrentOperations_itWillNotCrash() throws {
    let store = Store<AppState, TestDependenciesContainer>(
      interceptors: [],
      stateInitializer: { .init() },
      configuration: .init(
        stateInitializerAsyncProvider: DispatchQueue(label: "other"),
        listenersAsyncProvider: DispatchQueue(label: "test")
      )
    )

    let queue = OperationQueue()
    for i in 0 ..< 10 {
      queue.addOperation {
        let unsubscribe = store.addListener { _, _ in }
        try! Hydra.await( // swiftlint:disable:this force_try
          in: .background,
          store.dispatch(AddTodo(todo: .init(title: "Title", id: "\(i)")))
        )
        unsubscribe()
      }
    }

    queue.waitUntilAllOperationsAreFinished()
  }
}
