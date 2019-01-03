//
//  ActionDescriptionTests.swift
//  KatanaTests
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import XCTest

class LegacyActionDescriptionTests: XCTestCase {
  
  // MARK: - Actions
  func testActionDescription() {
    let action = RemoveTodoAction(id: "")
    XCTAssertEqual(action.debugDescription, "KatanaTests.RemoveTodoAction")
  }
  
  func testCustomActionDescription() {
    let action = AddTodoAction(title: "New todo")
    XCTAssertEqual(action.debugDescription, "KatanaTests.AddTodoAction.New todo")
  }
  
  // MARK: - Async Actions
  private func testableAction() -> AsyncTestAction {
    let expectation = self.expectation(description: "Store listener")
    let store = Store<AppState, SimpleDependencyContainer>()
    
    var action = AsyncTestAction(payload: 10)
    action.invokedLoadingClosure = {
      expectation.fulfill()
    }
    action.invokedCompletedClosure = {
      expectation.fulfill()
    }
    action.invokedFailedClosure = {
      expectation.fulfill()
    }
    
    store.dispatch(action)
    
    return action
  }
  
  func testLoadingAsyncActionDescription() {
    let action = self.testableAction()
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(action.debugDescription, "KatanaTests.AsyncTestAction.loading")
    }
  }
  
  func testCompletedInvoked() {
    let action = self.testableAction().completedAction {
      $0.completedPayload = "A"
    }
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(action.debugDescription, "KatanaTests.AsyncTestAction.completed")
    }
  }
  
  func testFailedInvoked() {
    let action = self.testableAction().failedAction {
      $0.failedPayload = "Error"
    }
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(action.debugDescription, "KatanaTests.AsyncTestAction.failed")
    }
  }
  
  func testProgressInvoked() {
    let action = self.testableAction().progressAction(percentage: 39.99)
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(action.debugDescription, "KatanaTests.AsyncTestAction.progress(39.99)")
    }
  }
}
