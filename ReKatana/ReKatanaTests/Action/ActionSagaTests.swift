//
//  ActionSagaTests.swift
//  ReKatana
//
//  Created by Mauro Bolis on 10/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

import Foundation
import XCTest
@testable import ReKatana

class ActionSagaModuleTests: XCTestCase {
  func testCanAddASyncAction() {
    
    typealias TestSyncActionType = SyncAction<Int>
    let SyncAction = SyncActionCreator<Int>(withName: "TestSyncAction")
    
    let spySaga: Saga<TestSyncActionType, AppReducer> = { action, getState, dispatch in }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionCreator: SyncAction)
    
    XCTAssertEqual(module.sagas.count, 1)
    XCTAssertEqual(module.sagas.keys.first, SyncAction.actionName)
  }


  func testCanAddAsyncAction() {
    typealias TestAsyncActionType = AsyncAction<Int, String, String>
    let AsyncAction = AsyncActionCreator<Int, String, String>(withName: "TestAsyncAction")
    
    let spySaga: Saga<TestAsyncActionType, AppReducer> = { action, getState, dispatch in }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionCreator: AsyncAction)
    
    XCTAssertEqual(module.sagas.count, 1)
    XCTAssertEqual(module.sagas.keys.first, AsyncAction.actionName)
  }
  
  func testReceiveSyncAction() {
    var invoked: Bool = false
    var invokedAction: TestSyncActionType?
    
    typealias TestSyncActionType = SyncAction<String>
    let SyncAction = SyncActionCreator<String>(withName: "TestSyncAction")
    
    let spySaga: Saga<TestSyncActionType, AppReducer> = { action, getState, dispatch in
      invoked = true
      invokedAction = action
    }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionCreator: SyncAction)
    
    let store = Store(AppReducer.self, middlewares: [
      SagaMiddleware.withSagaModules([
          module
        ])
      ])
    
    let action = SyncAction.with(payload: "PAYLOAD")
    store.dispatch(action)
    
    XCTAssertEqual(invoked, true)
    XCTAssertEqual(invokedAction?.actionName, action.actionName)
    XCTAssertEqual(invokedAction?.payload, action.payload)
  }
  
  func testReceiveAsyncAction() {
    var invoked: Bool = false
    var invokedAction: TestAsyncActionType?
    
    typealias TestAsyncActionType = AsyncAction<String, Int, Int>
    let AsyncAction = AsyncActionCreator<String, Int, Int>(withName: "TestAsyncAction")
    
    let spySaga: Saga<TestAsyncActionType, AppReducer> = { action, getState, dispatch in
      invoked = true
      invokedAction = action
    }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionCreator: AsyncAction)
    
    let store = Store(AppReducer.self, middlewares: [
      SagaMiddleware.withSagaModules([
        module
        ])
      ])
    
    let action = AsyncAction.with(payload: "PAYLOAD")
    store.dispatch(action)
    
    XCTAssertEqual(invoked, true)
    XCTAssertEqual(invokedAction?.actionName, action.actionName)
    XCTAssertEqual(invokedAction?.payload, action.payload)
    XCTAssertEqual(invokedAction?.completedPayload, action.completedPayload)
    XCTAssertEqual(invokedAction?.errorPayload, action.errorPayload)
  }
}
