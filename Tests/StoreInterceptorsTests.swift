//
//  StoreInterceptorsTests.swift
//  Katana
//
//  Copyright © 2021 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra
import XCTest

@testable import Katana

class StoreInterceptorsTests: XCTestCase {
  func testStoreInterceptor() {
    var dispatchedStateUpdater: AddTodo?
    var stateBefore: AppState?
    var stateAfter: AppState?
    let todo = Todo(title: "test", id: "id")

    let interceptor: StoreInterceptor = { context in
      return { next in
        return { stateUpdater in
          dispatchedStateUpdater = stateUpdater as? AddTodo
          stateBefore = context.getAnyState() as? AppState
          try next(stateUpdater)
          stateAfter = context.getAnyState() as? AppState
        }
      }
    }

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    XCTAssertNotNil(dispatchedStateUpdater)
    XCTAssertEqual(stateBefore?.todo.todos, [])
    XCTAssertEqual(stateAfter?.todo.todos, [todo])
  }

  func testStoreInterceptor_whenMultipleInterceptors_areExecutedInOrder() {
    let todo = Todo(title: "test", id: "id")

    var invocationOrder: [String] = []

    let firstInterceptor: StoreInterceptor = { _ in
      return { next in
        return { stateUpdater in
          invocationOrder.append("1")
          try next(stateUpdater)
        }
      }
    }

    let secondInterceptor: StoreInterceptor = { _ in
      return { next in
        return { stateUpdater in
          invocationOrder.append("2")
          try next(stateUpdater)
        }
      }
    }

    let thirdInterceptor: StoreInterceptor = { _ in
      return { next in
        return { stateUpdater in
          invocationOrder.append("3")
          try next(stateUpdater)
        }
      }
    }

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [firstInterceptor, secondInterceptor, thirdInterceptor])
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    XCTAssertEqual(invocationOrder, ["1", "2", "3"])
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testStoreInterceptor_whenInterceptorThrows_propagationIsBlocked() {
    let todo = Todo(title: "test", id: "id")

    var dispatchedStateUpdater: AddTodo?

    let interceptor: StoreInterceptor = { _ in
      return { _ in
        return { stateUpdater in
          dispatchedStateUpdater = stateUpdater as? AddTodo
          throw StoreInterceptorChainBlocked()
        }
      }
    }

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
    store.dispatch(AddTodo(todo: todo))

    self.waitFor { dispatchedStateUpdater != nil }
    XCTAssertEqual(store.state.todo.todos.count, 0)
  }

  func testStoreInterceptor_whenReturningSideEffect_re() {
    let todo = Todo(title: "title", id: "id")
    var dispatchedSideEffect: ReturningClosureSideEffect?
    var stateBefore: AppState?
    var stateAfter: AppState?

    let interceptor: StoreInterceptor = { context in
      return { next in
        return { dispatchable in
          if let dispatched = dispatchable as? ReturningClosureSideEffect {
            dispatchedSideEffect = dispatched

            try Hydra.await(context.dispatch(AddTodo(todo: todo)))

            stateBefore = context.getAnyState() as? AppState
            try next(dispatchable)
            stateAfter = context.getAnyState() as? AppState

          } else {
            try next(dispatchable)
          }
        }
      }
    }

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
    let returnedState = self.waitForPromise(
      store
        .dispatch(
          ReturningClosureSideEffect { context in
            try Hydra.await(context.dispatch(AddTodo(todo: todo)))
            return context.getState()
          }
        )
    )

    XCTAssertNotNil(dispatchedSideEffect)
    XCTAssertEqual(stateBefore?.todo.todos, [todo])
    XCTAssertEqual(stateAfter?.todo.todos, [todo, todo])
    XCTAssertEqual(returnedState.todo.todos, [todo, todo])
  }
}

struct ReturningClosureSideEffect: ReturningTestSideEffect {
  var invocationClosure: (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> AppState

  init(
    invocationClosure: @escaping (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> AppState
  ) {
    self.invocationClosure = invocationClosure
  }

  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> AppState {
    return try self.invocationClosure(context)
  }
}

struct StoreInterceptorChainBlocked: Error {}
