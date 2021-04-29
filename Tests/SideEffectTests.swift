//
//  SideEffectTests.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra
import XCTest

@testable import Katana

class SideEffectTests: XCTestCase {
  func testDispatch_invokesTheSideEffect() {
    let store = Store<AppState, TestDependenciesContainer>()
    let expectation = self.expectation(description: "SideEffect is invoked")

    store.dispatch(ClosureSideEffect(delay: 0) { _ in expectation.fulfill() })

    self.waitForExpectations(timeout: 10)
  }

  func testDispatch_invokesTheSideEffectWithTheSameDependencyContainer() {
    var firstDependenciesContainer: SideEffectDependencyContainer?
    var secondDependenciesContainer: SideEffectDependencyContainer?
    let sideEffect1 = ClosureSideEffect(delay: 0) { context in firstDependenciesContainer = context.dependencies }
    let sideEffect2 = ClosureSideEffect(delay: 0) { context in secondDependenciesContainer = context.dependencies }

    let store = Store<AppState, TestDependenciesContainer>()

    self.waitForPromise(
      store
        .dispatch(sideEffect1)
        .then { store.dispatch(sideEffect2) }
    )

    XCTAssertIdentical(firstDependenciesContainer, secondDependenciesContainer)
  }

  func testDispatch_whenUsingThen_invokesTheSideEffectsInProperOrder() {
    var invocationResults: [String] = []
    let sideEffect1 = ClosureSideEffect(delay: 3) { context in invocationResults.append("1") }
    let sideEffect2 = ClosureSideEffect(delay: 1) { context in invocationResults.append("2") }
    let sideEffect3 = ClosureSideEffect(delay: 0) { context in invocationResults.append("3") }

    let store = Store<AppState, TestDependenciesContainer>()

    self.waitForPromise(
      store
        .dispatch(sideEffect1)
        .then { store.dispatch(sideEffect2) }
        .then { store.dispatch(sideEffect3) }
    )

    XCTAssertEqual(invocationResults, ["1", "2", "3"])
  }

  func testDispatch_whenDispatchingFromSideEffect_dispatchesCorrectly() {
    var invocationResults: [String] = []
    let sideEffect1 = ClosureSideEffect(delay: 3) { context in invocationResults.append("1") }
    let sideEffect2 = ClosureSideEffect(delay: 1) { context in
      try Hydra.await(context.dispatch(sideEffect1))
      invocationResults.append("2")
    }
    let sideEffect3 = ClosureSideEffect(delay: 0) { context in invocationResults.append("3") }

    let store = Store<AppState, TestDependenciesContainer>()

    self.waitForPromise(
      store
        .dispatch(sideEffect2)
        .then { store.dispatch(sideEffect3) }
    )

    XCTAssertEqual(invocationResults, ["1", "2", "3"])
  }

  func testDispatch_whenDispatchingBothStateUpdatersAndSideEffects_handlesAllOfThem() {
    let todo = Todo(title: "title", id: "id")
    let user = User(username: "username")

    var firstState: AppState?
    var secondState: AppState?

    let sideEffect1 = ClosureSideEffect { context in
      firstState = context.getState()
    }

    let sideEffect2 = ClosureSideEffect { context in
      secondState = context.getState()
    }

    let addTodo = AddTodo(todo: todo)
    let addUser = AddUser(user: user)

    let store = Store<AppState, TestDependenciesContainer>()

    self.waitForPromise(
      store
        .dispatch(addTodo)
        .then { store.dispatch(sideEffect1) }
        .then { store.dispatch(addUser) }
        .then { store.dispatch(sideEffect2) }
    )

    XCTAssertEqual(firstState?.todo.todos, [todo])
    XCTAssertEqual(firstState?.user.users.isEmpty, true)

    XCTAssertEqual(secondState?.todo.todos, [todo])
    XCTAssertEqual(secondState?.user.users, [user])
  }

  func testGetState_returnsTheUpdatedState() {
    let todo = Todo(title: "title", id: "id")
    var firstState: AppState?
    var secondState: AppState?

    let store = Store<AppState, TestDependenciesContainer>()

    self.waitForPromise(
      store
        .dispatch(ClosureSideEffect { context in
          firstState = context.getState()
          try Hydra.await(context.dispatch(AddTodo(todo: todo)))
          secondState = context.getState()
        })
    )

    XCTAssertEqual(firstState?.todo.todos.count, 0)
    XCTAssertEqual(secondState?.todo.todos.count, 1)
    XCTAssertEqual(secondState?.todo.todos.first, todo)
  }

  func testDispatch_propagatesErrors() {
    let expectedError = NSError(domain: "Test error", code: -1, userInfo: nil)
    let store = Store<AppState, TestDependenciesContainer>()
    let expectation = self.expectation(description: "SideEffects and StatUpdaters are invoked")

    store
      .dispatch(ClosureSideEffect { context in throw expectedError })
      .then {
        XCTFail("then should not be invoked")
      }
      .catch { error in
        XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        expectation.fulfill()
      }

    self.waitForExpectations(timeout: 10)
  }

  func testReturningSideEffect() {
    let store = Store<AppState, TestDependenciesContainer>()

    let result = self.waitForPromise(
      store.dispatch(Multiply(a: 5, b: 2))
    )

    XCTAssertEqual(result, 10)
  }

  func testReturningSideEffect_whenNestedSideEffect_returnsComputedValue() {
    let store = Store<AppState, TestDependenciesContainer>()

    let result = self.waitForPromise(
      store.dispatch(ReentrantMultiply(a: 5, b: 2))
    )

    XCTAssertEqual(result, 20)
  }

  func testRetry_retriesDispatchable() {
    let store = Store<AppState, TestDependenciesContainer>()
    let expectation = self.expectation(description: "SideEffects is retried")

    store
      .dispatch(RetryMe())
      .retry(2)
      .then {
        expectation.fulfill()
      }

    self.waitForExpectations(timeout: 10)

    XCTAssertEqual(store.state.todo.todos.count, 2)
  }

  func testRetry_whenReturningSideEffect_returnsRetriedResult() {
    let store = Store<AppState, TestDependenciesContainer>()
    let expectation = self.expectation(description: "SideEffects is retried")

    store
      .dispatch(FailingMultiply(a: 5, b: 2))
      .retry(2)
      .then { result in
        XCTAssertEqual(result, 10)
        expectation.fulfill()
      }

    self.waitForExpectations(timeout: 10)

    XCTAssertEqual(store.state.todo.todos.count, 2)
  }
}

private struct Multiply: ReturningSideEffect {
  let a: Int
  let b: Int

  func sideEffect(_ context: AnySideEffectContext) throws -> Int {
    return self.a * self.b
  }
}

/// This sideEffect will fail the first time, but it will succeed if retried
private struct RetryMe: SideEffect {
  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws {
    try Hydra.await(context.dispatch(AddTodo(todo: Todo(title: "test", id: "test"))))
    if context.getState().todo.todos.count < 2 {
      throw NSError(domain: "Test error", code: -1, userInfo: nil)
    }
  }
}

private struct FailingMultiply: ReturningSideEffect {
  let a: Int
  let b: Int

  func sideEffect(_ context: AnySideEffectContext) throws -> Int {
    guard let typedContext = context as? SideEffectContext<AppState, TestDependenciesContainer> else {
      fatalError()
    }

    try Hydra.await(context.dispatch(AddTodo(todo: Todo(title: "New todo", id: UUID().uuidString))))

    guard typedContext.getState().todo.todos.count >= 2 else {
      throw NSError(domain: "Retry!", code: -1, userInfo: nil)
    }

    return self.a * self.b
  }
}

private struct ReentrantMultiply: ReturningSideEffect {
  let a: Int
  let b: Int

  func sideEffect(_ context: AnySideEffectContext) throws -> Int {
    let multiply = try Hydra.await(context.dispatch(Multiply(a: self.a, b: self.b)))
    return multiply * self.b
  }
}
