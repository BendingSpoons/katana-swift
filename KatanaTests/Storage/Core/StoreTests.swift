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
    let store = Store<AppReducer>()
    let state = store.state
    
    XCTAssertEqual(state.todo, TodoState())
    XCTAssertEqual(state.user, UserState())
  }
  
  func testDispatch() {
    let store = Store<AppReducer>()
    store.dispatch(AddTodoAction(title: "New Todo"))
    let newState = store.state

    XCTAssertEqual(newState.todo.todos.count, 1)
    XCTAssertEqual(newState.todo.todos[0].title, "New Todo")
  }
  
  func testListener() {
    let store = Store<AppReducer>()
    var newState: AppState? = nil
    
    _ = store.addListener { [unowned store] in
      newState = store.state
    }
    
    store.dispatch(AddTodoAction(title: "New Todo"))
    
    XCTAssertEqual(newState?.todo.todos.count, 1)
    XCTAssertEqual(newState?.todo.todos[0].title, "New Todo")
  }
  
  func testListenerRemove() {
    let store = Store<AppReducer>()
    var firstState: AppState? = nil
    var secondState: AppState? = nil
    
    let unsubscribe = store.addListener { [unowned store] in
      if firstState != nil {
        secondState = store.state
        
      } else {
        firstState = store.state
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
    let lastState = store.state
    let titles = lastState.todo.todos.map { $0.title }
    XCTAssertEqual(lastState.todo.todos.count, 2)
    XCTAssertEqual(titles.contains("New Todo"), true)
    XCTAssertEqual(titles.contains("Second Todo"), true)
  }
}
