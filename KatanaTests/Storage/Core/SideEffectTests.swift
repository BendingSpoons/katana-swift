//
//  SideEffectTests.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import XCTest

class SideEffectTests: XCTestCase {
  
  func testSideEffectInvoked() {
    var invoked = false
    let expectation = self.expectation(description: "Side effect")
    
    let action = SpyActionWithSideEffect(sideEffectInvokedClosure: { (_, _, _, _) in
      invoked = true
      expectation.fulfill()
    }, reduceInvokedClosure: nil)
    
    
    let store = Store<AppState>()
    store.dispatch(action)
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
      XCTAssert(invoked)
    }
  }
  
  func testSideEffectInvokedWithProperParameters() {
    var invoked = false
    var invokedState: AppState?
    var invokedContainer: SideEffectDependencyContainer?

    let expectation = self.expectation(description: "Side effect")
    
    let action = SpyActionWithSideEffect(sideEffectInvokedClosure: { (action, state, _, dependencyContainer)  in
      invoked = true
      invokedState = state as? AppState
      invokedContainer = dependencyContainer
      expectation.fulfill()
    }, reduceInvokedClosure: nil)

    
    let store = Store<AppState>(middlewares: [], dependencies: EmptySideEffectDependencyContainer.self)
    let initialState = store.state
    store.dispatch(action)
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
      XCTAssert(invoked)
      XCTAssertEqual(initialState, invokedState)
      XCTAssertNotNil(invokedContainer as? EmptySideEffectDependencyContainer)
    }
  }
  
  func containerInvokedWithProperState() {
    var invokedContainer: SideEffectDependencyContainer?
    
    let expectation = self.expectation(description: "Side effect")
    
    let action = SpyActionWithSideEffect(sideEffectInvokedClosure: { (action, state, _, dependencyContainer)  in
      invokedContainer = dependencyContainer
      expectation.fulfill()

    }, reduceInvokedClosure: nil)
    
    let store = Store<AppState>(middlewares: [], dependencies: SimpleDependencyContainer.self)
    let initialState = store.state
    store.dispatch(action)
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
      
      let c = invokedContainer as? SimpleDependencyContainer
      
      XCTAssertNotNil(c)
      XCTAssertEqual(c?.state, initialState)
    }
  }
  
  func testDispatchQueueAction() {
    
    var invocationOrder = [String]()
    let action1expectation = self.expectation(description: "Action1")
    let action2expectation = self.expectation(description: "Action2")
    
    let action2 = SpyActionWithSideEffect(sideEffectInvokedClosure: { (_, _, _, _) in
      invocationOrder.append("side effect 2")
    }) {
      invocationOrder.append("reducer 2")
      action2expectation.fulfill()
    }
    
    let action1 = SpyActionWithSideEffect(sideEffectInvokedClosure: { (_, _, dispatch,  _) in
      invocationOrder.append("side effect 1")
      dispatch(action2)
    }) {
      invocationOrder.append("reducer 1")
      action1expectation.fulfill()
    }
    
    let store = Store<AppState>(middlewares: [], dependencies: SimpleDependencyContainer.self)
    store.dispatch(action1)
    
    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
      
      XCTAssertEqual(invocationOrder, [
        "side effect 1", "reducer 1", "side effect 2", "reducer 2"
      ])
    }
  }
}
