//
//  AsyncActionTests.swift
//  Katana
//
//  Created by Mauro Bolis on 28/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import XCTest

fileprivate struct AsyncTestAction: AsyncAction {
  var loadingPayload: Int
  var completedPayload: String?
  var failedPayload: String?
  var state: AsyncActionState
  
  var invokedLoadingClosure: () -> Void = { _ in }
  var invokedCompletedClosure: () -> Void = { _ in }
  var invokedFailedClosure: () -> Void = { _ in }
  
  init(payload: Int) {
    self.loadingPayload = payload
    self.state = .loading
  }
  
  static func loadingReduce(state: inout AppState, action: AsyncTestAction) {
    action.invokedLoadingClosure()
  }
  
  static func completedReduce(state: inout AppState, action: AsyncTestAction) {
    action.invokedCompletedClosure()
  }
  
  static func failedReduce(state: inout AppState, action: AsyncTestAction) {
    action.invokedFailedClosure()
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
}
