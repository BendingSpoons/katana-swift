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
    
    let spySaga: Saga<SyncActions.LogoutActionType, AppReducer> = { action, getState, dispatch in }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionCreator: SyncActions.LogoutAction)
    
    XCTAssertEqual(module.sagas.count, 1)
    XCTAssertEqual(module.sagas.keys.first, SyncActions.LogoutAction.actionName)
  }


  func testCanAddAsyncAction() {
    let spySaga: Saga<AsyncActions.LoginActionType, AppReducer> = { action, getState, dispatch in }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionCreator: AsyncActions.LoginAction)
    
    XCTAssertEqual(module.sagas.count, 1)
    XCTAssertEqual(module.sagas.keys.first, AsyncActions.LoginAction.actionName)
  }
  
  func testReceiveSyncAction() {
    var invoked: Bool = false
    var invokedAction: SyncActions.LogoutActionType?
    
    let spySaga: Saga<SyncActions.LogoutActionType, AppReducer> = { action, getState, dispatch in
      invoked = true
      invokedAction = action
    }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionCreator: SyncActions.LogoutAction)
    
    let store = Store(AppReducer.self, middlewares: [
      SagaMiddleware.withSagaModules([
          module
        ])
      ])
    
    let action = SyncActions.LogoutAction.with(payload: "PAYLOAD")
    store.dispatch(action)
    
    XCTAssertEqual(invoked, true)
    XCTAssertEqual(invokedAction?.actionName, action.actionName)
    XCTAssertEqual(invokedAction?.payload, action.payload)
  }
  
  func testReceiveAsyncAction() {
    var invoked: Bool = false
    var invokedAction: AsyncActions.LoginActionType?
    
    let spySaga: Saga<AsyncActions.LoginActionType, AppReducer> = { action, getState, dispatch in
      invoked = true
      invokedAction = action
    }
    
    var module = SagaModule()
    module.addSaga(spySaga, forActionCreator: AsyncActions.LoginAction)
    
    let store = Store(AppReducer.self, middlewares: [
      SagaMiddleware.withSagaModules([
        module
        ])
      ])
    
    let action = AsyncActions.LoginAction.with(payload: "PAYLOAD")
    store.dispatch(action)
    
    XCTAssertEqual(invoked, true)
    XCTAssertEqual(invokedAction?.actionName, action.actionName)
    XCTAssertEqual(invokedAction?.payload, action.payload)
    XCTAssertEqual(invokedAction?.completedPayload, action.completedPayload)
    XCTAssertEqual(invokedAction?.errorPayload, action.errorPayload)
  }
}
