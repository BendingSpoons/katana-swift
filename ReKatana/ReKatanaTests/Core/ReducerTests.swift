//
//  ReKatanaTests.swift
//  ReKatanaTests
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import XCTest
@testable import ReKatana

class ReducerTests: XCTestCase {
  func testAddItem() {
    let state = TodoReducer.reduce(action: InitAction(), state: nil) // init performed by the store
    let firstState = TodoReducer.reduce(action: AddTodoAction(title: "New Todo"), state: state)
    
    XCTAssertEqual(firstState.todos.count, 1)
    XCTAssertEqual(firstState.todos[0].title, "New Todo")
    
    
    let secondState = TodoReducer.reduce(action: AddTodoAction(title: "New Todo 2"), state: firstState)
    XCTAssertEqual(secondState.todos.count, 2)
    XCTAssertEqual(secondState.todos[0].title, "New Todo")
    XCTAssertEqual(secondState.todos[1].title, "New Todo 2")
  }
  
  func testRemoveItem() {
    let initialState = TodoState(todos: [Todo(title: "Initial Todo", id: "UUID")])
    
    let state = TodoReducer.reduce(action: RemoveTodoAction(id: "NOUUID"), state: initialState)
    XCTAssertEqual(state.todos.count, 1)
    XCTAssertEqual(state.todos[0].title, "Initial Todo")
    
    let secondState = TodoReducer.reduce(action: RemoveTodoAction(id: "UUID"), state: state)
    XCTAssertEqual(secondState.todos.count, 0)
  }
  
  func testUnchangedState() {
    let state = TodoReducer.reduce(action: InitAction(), state: nil) // init performed by the store
    let firstState = TodoReducer.reduce(action: AddTodoAction(title: "New Todo"), state: state)
    
    let newState = TodoReducer.reduce(action: ExternalAction(), state: firstState)
    XCTAssertEqual(firstState, newState)
  }
}
