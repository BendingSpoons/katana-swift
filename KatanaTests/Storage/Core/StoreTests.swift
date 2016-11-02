//
//  storeTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
import XCTest
@testable import Katana

class StoreTests: XCTestCase {
  func testInitialState() {
    let store = Store<AppState>()
    let state = store.state
    
    XCTAssertEqual(state.todo, TodoState())
    XCTAssertEqual(state.user, UserState())
  }
  
  func testDispatch() {
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<AppState>()
    _ = store.addListener { expectation.fulfill() }
    store.dispatch(AddTodoAction(title: "New Todo"))
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      
      XCTAssertEqual(newState.todo.todos.count, 1)
      XCTAssertEqual(newState.todo.todos[0].title, "New Todo")
    }
  }
  
  func testListener() {
    let expectation = self.expectation(description: "Store listener")
    let store = Store<AppState>()
    var newState: AppState? = nil
    
    _ = store.addListener { [unowned store] in
      newState = store.state
      dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
      expectation.fulfill()
    }
    
    store.dispatch(AddTodoAction(title: "New Todo"))
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(newState?.todo.todos.count, 1)
      XCTAssertEqual(newState?.todo.todos[0].title, "New Todo")
    }
  }
  
  func testListenerRemove() {
    let expectation = self.expectation(description: "Store listener")
    let secondExpectation = self.expectation(description: "Second Store listener")
    
    let store = Store<AppState>()
    var firstState: AppState? = nil
    var secondState: AppState? = nil
    
    // listener just to fullfill expectations
    _ = store.addListener {
      if firstState != nil {
        secondExpectation.fulfill()
        
      } else {
        expectation.fulfill()
      }
    }
    
    let unsubscribe = store.addListener { [unowned store] in
      if firstState != nil {
        secondState = store.state
        
      } else {
        firstState = store.state
      }
    }
    
    store.dispatch(AddTodoAction(title: "New Todo"))
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
      unsubscribe()
      store.dispatch(AddTodoAction(title: "Second Todo"))
    })
    
    self.waitForExpectations(timeout: 2) { (err: Error?) in
      // first callback invoked
      XCTAssertEqual(firstState?.todo.todos.count, 1)
      XCTAssertEqual(firstState?.todo.todos[0].title, "New Todo")
      
      // no second callback invoked
      XCTAssertNil(secondState)
      
      // state is ok
      let lastState = store.state
      let titles = lastState.todo.todos.map { $0.title }
      XCTAssertEqual(lastState.todo.todos.count, 2)
      XCTAssertEqual(titles.contains("New Todo"), true)
      XCTAssertEqual(titles.contains("Second Todo"), true)
    }
  }
}
