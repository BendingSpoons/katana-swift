//
//  middlewareTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 09/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
import XCTest
@testable import Katana

/*class MiddlewareTests: XCTestCase {
  func testBasicMiddleware() {
    
    var dispatchedAction: Action?
    var storeBefore: Any?
    var storeAfter: Any?
  
    
    func basicMiddleware<RootReducer: Reducer>(store: Store<RootReducer>) -> 
                      (_ next: StoreDispatch) -> 
                      (_ action: Action) -> Void {
 
      return { next in
        return { action in
          dispatchedAction = action
          storeBefore = store.sta
          next(action)
          storeAfter = store.state
        }
      }
    }
    
    
    let store = Store<AppReducer>(middlewares: [basicMiddleware])
    
    let initialState = store.getState()
    let action = AddTodoAction(title: "New Todo")
    store.dispatch(action)
    let newState = store.getState()
    
    XCTAssertEqual(dispatchedAction as? AddTodoAction, action)
    XCTAssertEqual(storeBefore as? AppState, initialState)
    XCTAssertEqual(storeAfter as? AppState, newState)
  }
  
  
  func testMiddlewareChaining() {
    
    var dispatchedAction: Action?
    var storeBefore: Any?
    var storeAfter: Any?
    var invokationOrder: [String] = []
    
    func basicMiddleware<RootReducer: Reducer>(store: Store<RootReducer>) -> 
                                              (_ next: StoreDispatch) ->
                                              (_ action: Action) -> Void {
      return { next in
        return { action in
          invokationOrder.append("basic")
          dispatchedAction = action
          storeBefore = store.getState()
          next(action)
          storeAfter = store.getState()
        }
      }
    }
    
    func secondMiddleware<RootReducer: Reducer>(store: Store<RootReducer>) -> 
                                                (_ next: StoreDispatch) ->
                                                (_ action: Action) -> Void {
      return { next in
        return { action in
          invokationOrder.append("second")
        }
      }
    }
    
    
    let store = Store<AppReducer>(middlewares: [basicMiddleware, secondMiddleware])
    
    let initialState = store.getState()
    let action = AddTodoAction(title: "New Todo")
    store.dispatch(action)
    let newState = store.getState()
    
    XCTAssertEqual(invokationOrder, ["basic", "second"])
    XCTAssertEqual(dispatchedAction as? AddTodoAction, action)
    XCTAssertEqual(storeBefore as? AppState, initialState)
    XCTAssertEqual(storeAfter as? AppState, newState)
  }
}*/
