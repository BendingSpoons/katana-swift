//
//  SagaTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 09/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
import XCTest
@testable import Katana

class SagaTests: XCTestCase {
  func testShouldInvokeSaga() {
    var invoked: Bool = false
    var invokedAction: Any?
    
    let spySaga: Saga<AddTodoAction, AppReducer, AppSagaProviderContainer> = { action, getState, dispatch, providers in
      invoked = true
      invokedAction = action
    }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionNamed: "AddTodo")
    
    let store = Store<AppReducer>(middlewares: [
      SagaMiddleware.withSagaModules([
        module
      ], providersContainer: AppSagaProviderContainer.self)
    ])
    
    let action = AddTodoAction(title: "New Todo")
    store.dispatch(action)
    let newState = store.getState()
    
    XCTAssertEqual(invoked, true)
    XCTAssertEqual(invokedAction as? AddTodoAction, action)
    XCTAssertEqual(newState.todo.todos.count, 1)
    XCTAssertEqual(newState.todo.todos[0].title, "New Todo")
  }
  
  func testShouldNotInvokeSaga() {
    var invoked: Bool = false
    
    let spySaga: Saga<AddTodoAction, AppReducer, AppSagaProviderContainer> = { action, getState, dispatch, providers in
      invoked = true
    }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionNamed: "AddTodo")
    
    let store = Store<AppReducer>(middlewares: [
      SagaMiddleware.withSagaModules([
        module
        ], providersContainer: AppSagaProviderContainer.self)
      ])

    let action = RemoveTodoAction(id: "A")
    store.dispatch(action)
    
    XCTAssertEqual(invoked, false)
  }
  
  func testShouldDispatch() {
    var invokations = 0

    let doubleTodoSaga: Saga<AddTodoAction, AppReducer, AppSagaProviderContainer> = { action, getState, dispatch, providers in
      invokations = invokations + 1

      if (action.title == "double") {
        dispatch(AddTodoAction(title: "double todo"))
      }
    }
    
    var module = SagaModule()
    module.addSaga(doubleTodoSaga, forActionNamed: "AddTodo")
    
    let store = Store<AppReducer>(middlewares: [
      SagaMiddleware.withSagaModules([
        module
        ], providersContainer: AppSagaProviderContainer.self)
      ])
  
    let action = AddTodoAction(title: "double")
    store.dispatch(action)
    
    let newState = store.getState()
    let todoTitles = newState.todo.todos.map { $0.title }
    
    XCTAssertEqual(invokations, 2)
    XCTAssertEqual(newState.todo.todos.count, 2)
    XCTAssertEqual(todoTitles.contains("double"), true)
    XCTAssertEqual(todoTitles.contains("double todo"), true)
  }
  
  func testShouldGetProperSate() {
    var firstInvokationState: AppState?
    var secondInvokationState: AppState?
    
    let spySaga: Saga<AddTodoAction, AppReducer, AppSagaProviderContainer> = { action, getState, dispatch, providers in
      if firstInvokationState != nil {
        secondInvokationState = getState()
      } else {
        firstInvokationState = getState()
      }
    }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionNamed: "AddTodo")
    
    let store = Store<AppReducer>(middlewares: [
      SagaMiddleware.withSagaModules([
        module
        ], providersContainer: AppSagaProviderContainer.self)
      ])

    let initialState = store.getState()
    store.dispatch(AddTodoAction(title: "A"))
    
    let secondState = store.getState()
    store.dispatch(AddTodoAction(title: "B"))
    
    XCTAssertEqual(firstInvokationState, initialState)
    XCTAssertEqual(secondInvokationState, secondState)
  }
  
  func testShouldManageMultipleModules() {
    var sagaOneInvoked: Bool = false
    var sagaTwoInvoked: Bool = false
    
    let sagaOne: Saga<AddTodoAction, AppReducer, AppSagaProviderContainer> = { action, getState, dispatch, providers in
      sagaOneInvoked = true
    }
    
    let sagaTwo: Saga<RemoveTodoAction, AppReducer, AppSagaProviderContainer> = { action, getState, dispatch, providers in
      sagaTwoInvoked = true
    }
    
    var moduleOne = SagaModule()
    moduleOne.addSaga(sagaOne, forActionNamed: "AddTodo")
    
    var moduleTwo = SagaModule()
    moduleTwo.addSaga(sagaTwo, forActionNamed: "RemoveTodo")
    
    let store = Store<AppReducer>(middlewares: [
      SagaMiddleware.withSagaModules([
        moduleOne, moduleTwo
        ], providersContainer: AppSagaProviderContainer.self)
      ])
    
    store.dispatch(AddTodoAction(title: "TITLE"))
    store.dispatch(RemoveTodoAction(id: "ID"))
    
    XCTAssertEqual(sagaOneInvoked, true)
    XCTAssertEqual(sagaTwoInvoked, true)
  }
  
  func testShouldAbleToUseProviders() {
    var baseURL: String? = nil
    
    let spySaga: Saga<AddTodoAction, AppReducer, AppSagaProviderContainer> = { action, getState, dispatch, providers in
      baseURL = providers.informationProvider?.getBaseURL()
    }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionNamed: "AddTodo")
    
    let store = Store<AppReducer>(middlewares: [
      SagaMiddleware.withSagaModules(
        [module],
        providersContainer: AppSagaProviderContainer.self)
      ])
    
    store.dispatch(AddTodoAction(title: "TITLE"))
    
    XCTAssertEqual(baseURL, InformationProvider.getBaseURL())
  }
}
