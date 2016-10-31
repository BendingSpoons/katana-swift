//
//  middlewareTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 09/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
import XCTest
@testable import Katana

class MiddlewareTests: XCTestCase {
  func testBasicMiddleware() {
    
    var dispatchedAction: AnyAction?
    var storeBefore: Any?
    var storeAfter: Any?
    
    let expectation = self.expectation(description: "Middlewares")
    
    let middleware: StoreMiddleware<AppState> = { getState, dispatch in
      return { next in
        return { action in
          dispatchedAction = action
          storeBefore = getState()
          next(action)
          storeAfter = getState()
          expectation.fulfill()
        }
      }
    }
    
    let store = Store<AppState>(middlewares: [middleware], dependencies: EmptySideEffectDependencyContainer.self)
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
    
    let expectation = self.expectation(description: "Middlewares")
    
    let basicMiddleware: StoreMiddleware<AppState> = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("basic")
          next(action)
        }
      }
    }
    
    let secondMiddleware: StoreMiddleware<State> = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("second")
          expectation.fulfill()
        }
      }
    }
    
    let store = Store<AppState>(
      middlewares: [basicMiddleware, secondMiddleware],
      dependencies: EmptySideEffectDependencyContainer.self
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
    var dispatchedAction: AnyAction?
    var storeBefore: Any?
    var storeAfter: Any?
    var invokationOrder: [String] = []
    
    let expectation = self.expectation(description: "Middlewares")
    
    let basicMiddleware: StoreMiddleware<AppState> = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("basic")
          dispatchedAction = action
          storeBefore = getState()
          next(action)
          storeAfter = getState()
        }
      }
    }
    
    let secondMiddleware: StoreMiddleware<AppState> = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("second")
          expectation.fulfill()
          next(action)
        }
      }
    }
    
    let store = Store<AppState>(
      middlewares: [basicMiddleware, secondMiddleware],
      dependencies: EmptySideEffectDependencyContainer.self
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
    
    let expectation = self.expectation(description: "Middlewares")
    
    let basicMiddleware: StoreMiddleware<AppState> = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("basic")
          next(action)
        }
      }
    }
    
    let secondMiddleware: StoreMiddleware<State> = { getState, dispatch in
      return { next in
        return { action in
          invokationOrder.append("second")
          expectation.fulfill()
          next(action)
        }
      }
    }
    
    let store = Store<AppState>(
      middlewares: [basicMiddleware, secondMiddleware],
      dependencies: EmptySideEffectDependencyContainer.self
    )
    
    let action = AddTodoAction(title: "New Todo")
    store.dispatch(action)
    
    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(error)
      XCTAssertEqual(invokationOrder, ["basic", "second"])
    }
  }
}
