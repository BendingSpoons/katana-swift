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
  
  var invokedLoadingClosure: () -> () = { _ in }
  var invokedCompletedClosure: () -> () = { _ in }
  var invokedFailedClosure: () -> () = { _ in }
  var invokedSideEffectClosure: () -> () = { _ in }
  
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
  
  func sideEffect(state: State,
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
    
    var action = AsyncTestAction(payload: 10).completedAction(payload: "A")
    
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
    
    var action = AsyncTestAction(payload: 10).failedAction(payload: "Error")
    
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
  
  func testCompletedAction() {
    let action = AsyncTestAction(payload: 10)
    let completedAction = action.completedAction(payload: "A")
    
    XCTAssertEqual(completedAction.state, .completed)
    XCTAssertEqual(completedAction.loadingPayload, action.loadingPayload)
    XCTAssertEqual(completedAction.completedPayload, "A")
  }
  
  func testFailedAction() {
    let action = AsyncTestAction(payload: 10)
    let completedAction = action.failedAction(payload: "Error")
    
    XCTAssertEqual(completedAction.state, .failed)
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
    var action = AsyncTestAction(payload: 10).completedAction(payload: "A")
    
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
    var action = AsyncTestAction(payload: 10).failedAction(payload: "A")
    
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
