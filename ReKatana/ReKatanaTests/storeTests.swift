//
//  storeTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
import XCTest
@testable import ReKatana

class StoreTests: XCTestCase {
  func testInitialState() {
    let store = Store(AppReducer.self)
    let state = store.getState()
    
    XCTAssertEqual(state.todo, TodoReducer.initialState)
    XCTAssertEqual(state.user, UserReducer.initialState)
  }
  
  func testDispatch() {
    let store = Store(AppReducer.self)
    store.dispatch(AddTodoAction(title: "New Todo"))
    let newState = store.getState()

    XCTAssertEqual(newState.todo.todos.count, 1)
    XCTAssertEqual(newState.todo.todos[0].title, "New Todo")
  }
  
  func testListener() {
    let store = Store(AppReducer.self)
    var newState: AppState? = nil
    
    _ = store.addListener { store in
      newState = store.getState()
    }
    
    store.dispatch(AddTodoAction(title: "New Todo"))
    
    XCTAssertEqual(newState?.todo.todos.count, 1)
    XCTAssertEqual(newState?.todo.todos[0].title, "New Todo")
  }
  
  func testListenerRemove() {
    let store = Store(AppReducer.self)
    var firstState: AppState? = nil
    var secondState: AppState? = nil
    
    let unsubscribe = store.addListener {
      if firstState != nil {
        secondState = $0.getState()
        
      } else {
        firstState = $0.getState()
      }
    }
    
    store.dispatch(AddTodoAction(title: "New Todo"))
    unsubscribe()
    store.dispatch(AddTodoAction(title: "Second Todo"))
    
    // first callback invoked
    XCTAssertEqual(firstState?.todo.todos.count, 1)
    XCTAssertEqual(firstState?.todo.todos[0].title, "New Todo")
    
    // no second callback invoked
    XCTAssertNil(secondState)
    
    // state is ok
    let lastState = store.getState()
    let titles = lastState.todo.todos.map { $0.title }
    XCTAssertEqual(lastState.todo.todos.count, 2)
    XCTAssertEqual(titles.contains("New Todo"), true)
    XCTAssertEqual(titles.contains("Second Todo"), true)
  }
}
