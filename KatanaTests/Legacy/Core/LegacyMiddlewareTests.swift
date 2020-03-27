//
//  MiddlewareTests.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import XCTest
@testable import Katana

class MiddlewareTests: XCTestCase {
  func testBasicMiddleware() {

    var dispatchedAction: Action?
    var storeBefore: Any?
    var storeAfter: Any?

    let expectation = self.expectation(description: "Middleware")

    let middleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          dispatchedAction = action as? Action
          storeBefore = getState()
          next(action)
          storeAfter = getState()
          expectation.fulfill()
        }
      }
    }

    let store = Store<AppState, EmptySideEffectDependencyContainer>(
      interceptors: [
        middlewareToInterceptor(middleware)
      ]
    )

    let initialState = store.state
    let action = AddTodoAction(title: "New Todo")
    store.dispatch(action)

    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(error)

      let newState = store.state
      XCTAssertEqual(dispatchedAction as? AddTodoAction, action)
      XCTAssertEqual(storeBefore as? AppState, initialState)
      XCTAssertEqual(storeAfter as? AppState, newState)
    }
  }

  func testMiddlewareCanBlockPropagation() {
    var invocationOrder: [String] = []

    let expectation = self.expectation(description: "Middleware")

    let basicMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invocationOrder.append("basic")
          next(action)
          expectation.fulfill()
        }
      }
    }

    let secondMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invocationOrder.append("second")
        }
      }
    }

    let thirdMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invocationOrder.append("third")
          next(action)
        }
      }
    }

    let store = Store<AppState, EmptySideEffectDependencyContainer>(
      interceptors: [
        middlewareToInterceptor(basicMiddleware),
        middlewareToInterceptor(secondMiddleware),
        middlewareToInterceptor(thirdMiddleware),
      ]
    )

    let action = AddTodoAction(title: "New Todo")
    let initialState = store.state
    store.dispatch(action)

    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(error)
      XCTAssertEqual(invocationOrder, ["basic", "second"])
      XCTAssertEqual(store.state, initialState)
    }
  }

  func testMiddlewareChaining() {
    var dispatchedAction: Action?
    var invocationOrder: [String] = []

    let expectation = self.expectation(description: "Middleware")

    let basicMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invocationOrder.append("basic")
          dispatchedAction = action as? Action
          next(action)
          expectation.fulfill()
        }
      }
    }

    let secondMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invocationOrder.append("second")
          next(action)
        }
      }
    }

    let thirdMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invocationOrder.append("third")
          next(action)
        }
      }
    }

    let store = Store<AppState, EmptySideEffectDependencyContainer>(
      interceptors: [
        middlewareToInterceptor(basicMiddleware),
        middlewareToInterceptor(secondMiddleware),
        middlewareToInterceptor(thirdMiddleware),
      ]
    )
    
    let initialState = store.state
    let action = AddTodoAction(title: "New Todo")
    store.dispatch(action)

    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(error)

      let newState = store.state
      XCTAssertEqual(invocationOrder, ["basic", "second", "third"])
      XCTAssertEqual(dispatchedAction as? AddTodoAction, action)
      XCTAssertEqual(initialState.todo.todos.count + 1, newState.todo.todos.count)
    }
  }

  func testGenericMiddleware() {
    var invocationOrder: [String] = []

    let expectation = self.expectation(description: "Middleware")

    let basicMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invocationOrder.append("basic")
          next(action)
        }
      }
    }

    let secondMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invocationOrder.append("second")
          expectation.fulfill()
          next(action)
        }
      }
    }

    let store = Store<AppState, EmptySideEffectDependencyContainer>(
      interceptors: [
        middlewareToInterceptor(basicMiddleware),
        middlewareToInterceptor(secondMiddleware),
      ]
    )

    let action = AddTodoAction(title: "New Todo")
    store.dispatch(action)

    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(error)
      XCTAssertEqual(invocationOrder, ["basic", "second"])
    }
  }

  func testMiddlewareInitializedImmediately() {

    var invoked = false
    let expectation = self.expectation(description: "Middleware")

    let basicMiddleware: StoreMiddleware = { getState, dispatch in
      invoked = true
      expectation.fulfill()

      return { next in
        return { action in
          next(action)
        }
      }
    }

    let store = Store<AppState, EmptySideEffectDependencyContainer>(
      interceptors: [
        middlewareToInterceptor(basicMiddleware)
      ]
    )

    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(error)
      XCTAssert(invoked)
    }
  }
}
