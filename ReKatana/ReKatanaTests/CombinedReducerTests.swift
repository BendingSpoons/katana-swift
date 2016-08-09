//
//  CombinedReducerTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import XCTest
@testable import ReKatana

class CombinedReducerTests: XCTestCase {
  func testAddItem() {
    let state = AppReducer.reduce(action: InitAction(), state: nil) // init performed by the store
    let newState = AppReducer.reduce(action: AddTodoAction(title: "New Todo"), state: state)
    
    XCTAssertEqual(newState.todo.todos.count, 1)
    XCTAssertEqual(newState.todo.todos[0].title, "New Todo")
    XCTAssertEqual(newState.user, state.user)
  }
  
  func testUnchangedState() {
    let state = AppReducer.reduce(action: InitAction(), state: nil) // init performed by the store
    let firstState = AppReducer.reduce(action: AddTodoAction(title: "New Todo"), state: state)
    
    let newState = AppReducer.reduce(action: ExternalAction(), state: firstState)
    XCTAssertEqual(firstState, newState)
  }
}
