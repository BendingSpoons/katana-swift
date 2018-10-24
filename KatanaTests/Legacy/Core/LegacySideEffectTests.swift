//
//  SideEffectTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import XCTest

class LegacySideEffectTests: XCTestCase {

  func testSideEffectInvoked() {
    var invoked = false
    let expectation = self.expectation(description: "Side effect")

    let action = SpyActionWithSideEffect(sideEffectInvokedClosure: { (_, _, _, _) in
      invoked = true
      expectation.fulfill()
    }, updatedInvokedClosure: nil)

    let store = Store<AppState, SimpleDependencyContainer>()
    store.dispatch(action)

    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
      XCTAssert(invoked)
    }
  }

  func testSideEffectInvokedWithProperParameters() {
    var invoked = false
    var invokedCurrentState: AppState?
    var invokedPreviousState: AppState?
    var invokedContainer: SideEffectDependencyContainer?

    let expectation = self.expectation(description: "Side effect")

    let action = SpyActionWithSideEffect(sideEffectInvokedClosure: { (currentState, previousState, _, dependencyContainer)  in
      invoked = true
      invokedCurrentState = currentState as? AppState
      invokedPreviousState = previousState as? AppState
      invokedContainer = dependencyContainer
      expectation.fulfill()
    }, updatedInvokedClosure: nil)
    
    let store = Store<AppState, SimpleDependencyContainer>()
    let initialState = store.state
    store.dispatch(action)

    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
      XCTAssert(invoked)
      XCTAssertEqual(initialState, invokedPreviousState)
      XCTAssertEqual(store.state, invokedCurrentState)
      XCTAssertNotNil(invokedContainer as? EmptySideEffectDependencyContainer)
    }
  }

  func testSideEffectInvokedWithSameContainer() {
    var firstInvokedContainer: SideEffectDependencyContainer?
    var secondInvokedContainer: SideEffectDependencyContainer?

    let expectation = self.expectation(description: "Side effect")

    let action = SpyActionWithSideEffect(sideEffectInvokedClosure: { (_, _, _, dependencyContainer)  in
      firstInvokedContainer = dependencyContainer

    }, updatedInvokedClosure: nil)
    
    let secondAction = SpyActionWithSideEffect(sideEffectInvokedClosure: { (_, _, _, dependencyContainer)  in
      secondInvokedContainer = dependencyContainer
      expectation.fulfill()
      
    }, updatedInvokedClosure: nil)
    
    let store = Store<AppState, SimpleDependencyContainer>()
    
    store.dispatch(action)
    store.dispatch(secondAction)

    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)
      XCTAssertNotNil(firstInvokedContainer)
      XCTAssertNotNil(secondInvokedContainer)
      XCTAssertTrue(firstInvokedContainer === secondInvokedContainer)
    }
  }

  func testDispatchQueueAction() {

    var invocationOrder = [String]()
    let action1expectation = self.expectation(description: "Action1")
    let action2expectation = self.expectation(description: "Action2")

    let action2 = SpyActionWithSideEffect(sideEffectInvokedClosure: { (_, _, _, _) in
      invocationOrder.append("side effect 2")
    }) {
      invocationOrder.append("update state 2")
      action2expectation.fulfill()
    }

    let action1 = SpyActionWithSideEffect(sideEffectInvokedClosure: { (_, _, dispatch, _) in
      invocationOrder.append("side effect 1")
      dispatch(action2)
    }) {
      invocationOrder.append("update state 1")
      action1expectation.fulfill()
    }
    
    let store = Store<AppState, SimpleDependencyContainer>()
    store.dispatch(action1)

    self.waitForExpectations(timeout: 10) { (error) in
      XCTAssertNil(error)

      XCTAssertEqual(invocationOrder, [
        "update state 1", "side effect 1", "update state 2", "side effect 2"
      ])
    }
  }
}
