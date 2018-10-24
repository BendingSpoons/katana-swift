//
//  MiddlewareTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
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
    var invokationOrder: [String] = []

    let expectation = self.expectation(description: "Middleware")

    let basicMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("basic")
          next(action)
        }
      }
    }

    let secondMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("second")
          expectation.fulfill()
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
    let initialState = store.state
    store.dispatch(action)

    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(error)
      XCTAssertEqual(invokationOrder, ["basic", "second"])
      XCTAssertEqual(store.state, initialState)
    }
  }

  func testMiddlewareChaining() {
    var dispatchedAction: Action?
    var storeBefore: Any?
    var storeAfter: Any?
    var invokationOrder: [String] = []

    let expectation = self.expectation(description: "Middleware")

    let basicMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("basic")
          dispatchedAction = action as? Action
          storeBefore = getState()
          next(action)
          storeAfter = getState()
        }
      }
    }

    let secondMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("second")
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
    
    let initialState = store.state
    let action = AddTodoAction(title: "New Todo")
    store.dispatch(action)

    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(error)

      let newState = store.state
      XCTAssertEqual(invokationOrder, ["basic", "second"])
      XCTAssertEqual(dispatchedAction as? AddTodoAction, action)
      XCTAssertEqual(storeBefore as? AppState, initialState)
      XCTAssertEqual(storeAfter as? AppState, newState)
    }
  }

  func testGenericMiddleware() {
    var invokationOrder: [String] = []

    let expectation = self.expectation(description: "Middleware")

    let basicMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("basic")
          next(action)
        }
      }
    }

    let secondMiddleware: StoreMiddleware = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("second")
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
      XCTAssertEqual(invokationOrder, ["basic", "second"])
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
