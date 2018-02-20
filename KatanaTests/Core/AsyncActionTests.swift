//
//  AsyncActionTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import XCTest

fileprivate struct AsyncTestAction: AsyncAction, ActionWithSideEffect {
  var loadingPayload: Int
  var completedPayload: String?
  var failedPayload: String?
  var state: AsyncActionState

  var invokedLoadingClosure: () -> () = { }
  var invokedCompletedClosure: () -> () = { }
  var invokedFailedClosure: () -> () = { }
  var invokedProgressClosure: (Double) -> () = { _ in }
  var invokedSideEffectClosure: () -> () = { }

  init(payload: Int) {
    self.loadingPayload = payload
    self.state = .loading
  }

  func updatedStateForLoading(currentState: State) -> State {
    self.invokedLoadingClosure()
    return currentState
  }

  func updatedStateForCompleted(currentState: State) -> State {
    self.invokedCompletedClosure()
    return currentState
  }

  func updatedStateForFailed(currentState: State) -> State {
    self.invokedFailedClosure()
    return currentState
  }
  
  fileprivate func updatedStateForProgress(currentState: State) -> State {
    self.invokedProgressClosure(self.state.progressPercentage!)
    return currentState
  }
  
  public func sideEffect(
    currentState: State,
    previousState: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer) {

    self.invokedSideEffectClosure()
  }
}

class AsyncActionTests: XCTestCase {
  func testLoadingInvoked() {
    var invokedLoading = false
    var invokedCompleted = false
    var invokedFailed = false

    let expectation = self.expectation(description: "Store listener")

    let store = Store<AppState>()

    var action = AsyncTestAction(payload: 10)
    action.invokedLoadingClosure = {
      invokedLoading = true
      expectation.fulfill()
    }

    action.invokedCompletedClosure = {
      invokedCompleted = true
      expectation.fulfill()
    }

    action.invokedFailedClosure = {
      invokedFailed = true
      expectation.fulfill()
    }

    store.dispatch(action)

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertNil(err)
      XCTAssertTrue(invokedLoading)
      XCTAssertFalse(invokedCompleted)
      XCTAssertFalse(invokedFailed)
    }
  }

  func testCompletedInvoked() {
    var invokedLoading = false
    var invokedCompleted = false
    var invokedFailed = false

    let expectation = self.expectation(description: "Store listener")

    let store = Store<AppState>()

    var action = AsyncTestAction(payload: 10).completedAction {
      $0.completedPayload = "A"
    }

    action.invokedLoadingClosure = {
      invokedLoading = true
      expectation.fulfill()
    }

    action.invokedCompletedClosure = {
      invokedCompleted = true
      expectation.fulfill()
    }

    action.invokedFailedClosure = {
      invokedFailed = true
      expectation.fulfill()
    }

    store.dispatch(action)

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertNil(err)
      XCTAssertFalse(invokedLoading)
      XCTAssertTrue(invokedCompleted)
      XCTAssertFalse(invokedFailed)
    }
  }

  func testFailedInvoked() {
    var invokedLoading = false
    var invokedCompleted = false
    var invokedFailed = false

    let expectation = self.expectation(description: "Store listener")

    let store = Store<AppState>()

    var action = AsyncTestAction(payload: 10).failedAction {
      $0.failedPayload = "Error"
    }

    action.invokedLoadingClosure = {
      invokedLoading = true
      expectation.fulfill()
    }

    action.invokedCompletedClosure = {
      invokedCompleted = true
      expectation.fulfill()
    }

    action.invokedFailedClosure = {
      invokedFailed = true
      expectation.fulfill()
    }

    store.dispatch(action)

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertNil(err)
      XCTAssertFalse(invokedLoading)
      XCTAssertFalse(invokedCompleted)
      XCTAssertTrue(invokedFailed)
    }
  }
  
  func testProgressInvoked() {
    var invokedLoading = false
    var invokedCompleted = false
    var invokedFailed = false
    var invokedProgress = false
    var progressAmount: Double?
    
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<AppState>()
    
    var action = AsyncTestAction(payload: 10).progressAction(percentage: 39.99)
    
    action.invokedLoadingClosure = {
      invokedLoading = true
      expectation.fulfill()
    }
    
    action.invokedCompletedClosure = {
      invokedCompleted = true
      expectation.fulfill()
    }
    
    action.invokedFailedClosure = {
      invokedFailed = true
      expectation.fulfill()
    }
    
    action.invokedProgressClosure = {
      invokedProgress = true
      progressAmount = $0
      expectation.fulfill()
    }
    
    store.dispatch(action)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertNil(err)
      XCTAssertFalse(invokedLoading)
      XCTAssertFalse(invokedCompleted)
      XCTAssertTrue(invokedProgress)
      XCTAssertEqual(progressAmount, 39.99)
      XCTAssertFalse(invokedFailed)
    }
  }

  func testCompletedAction() {
    let action = AsyncTestAction(payload: 10)
    
    let completedAction = action.completedAction {
      $0.completedPayload = "A"
    }

    XCTAssertEqual(completedAction.state, AsyncActionState.completed)
    XCTAssertEqual(completedAction.loadingPayload, action.loadingPayload)
    XCTAssertEqual(completedAction.completedPayload, "A")
  }

  func testFailedAction() {
    let action = AsyncTestAction(payload: 10)
    
    let completedAction = action.failedAction {
      $0.failedPayload = "Error"
    }

    XCTAssertEqual(completedAction.state, AsyncActionState.failed)
    XCTAssertEqual(completedAction.loadingPayload, action.loadingPayload)
    XCTAssertEqual(completedAction.failedPayload, "Error")
  }

  func testSideEffectLoading() {
    var invoked = false

    let expectation = self.expectation(description: "Store listener")
    let store = Store<AppState>()
    var action = AsyncTestAction(payload: 10)

    action.invokedSideEffectClosure = {
      invoked = true
      expectation.fulfill()
    }

    store.dispatch(action)

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertNil(err)
      XCTAssertTrue(invoked)
    }
  }

  func testSideEffectCompleted() {
    var invoked = false

    let expectation = self.expectation(description: "Store listener")
    let store = Store<AppState>()
    
    var action = AsyncTestAction(payload: 10).completedAction {
      $0.failedPayload = "Error"
    }

    action.invokedSideEffectClosure = {
      invoked = true
      expectation.fulfill()
    }

    store.dispatch(action)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      expectation.fulfill()
    }

    self.waitForExpectations(timeout: 10.0) { (err: Error?) in
      XCTAssertNil(err)
      XCTAssertFalse(invoked)
    }
  }

  func testSideEffectFailed() {
    var invoked = false

    let expectation = self.expectation(description: "Store listener")
    let store = Store<AppState>()
    
    var action = AsyncTestAction(payload: 10).failedAction {
      $0.failedPayload = "A"
    }

    action.invokedSideEffectClosure = {
      invoked = true
      expectation.fulfill()
    }

    store.dispatch(action)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      expectation.fulfill()
    }

    self.waitForExpectations(timeout: 10.0) { (err: Error?) in
      XCTAssertNil(err)
      XCTAssertFalse(invoked)
    }
  }
  
  func testSideEffectProgress() {
    var invoked = false
    
    let expectation = self.expectation(description: "Store listener")
    let store = Store<AppState>()
    
    var action = AsyncTestAction(payload: 10).progressAction(percentage: 10)
    
    action.invokedSideEffectClosure = {
      invoked = true
      expectation.fulfill()
    }
    
    store.dispatch(action)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 10.0) { (err: Error?) in
      XCTAssertNil(err)
      XCTAssertFalse(invoked)
    }
  }
}
