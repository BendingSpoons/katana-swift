//
//  ActionLinkerTests.swift
//  Katana
//
//  Created by Riccardo Cipolleschi on 12/01/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//
import Foundation
import XCTest
@testable import Katana

class ActionLinkerTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
    
  override func tearDown() {
    super.tearDown()
  }

  //MARK Creation tests
  func testCreationEmpty() {
    let actionLinker = ActionLinker(links: [])
    XCTAssertTrue(actionLinker.links.isEmpty)
  }
  
  func testCreationOneSourceActionOneLink() {
    let actionLinker = ActionLinker(links: [ActionLinks(source: BaseAction.self, links: [LinkedAction1.self])])
    XCTAssertEqual(actionLinker.links.count, 1)
    XCTAssertEqual(actionLinker.links[String(reflecting:BaseAction.self)]!.count, 1)
    
  }

  func testCreationOneSourceActionTwoLinks() {
    let actionLinker = ActionLinker(links: [ActionLinks(source: BaseAction.self,
                                                       links: [LinkedAction1.self, LinkedAction1.self])])
    XCTAssertEqual(actionLinker.links.count, 1)
    XCTAssertEqual(actionLinker.links[String(reflecting:BaseAction.self)]!.count, 2)
  }
  
  func testCreationTwoSourceActionOneLink() {
    let actionLinker = ActionLinker(links: [ActionLinks(source: BaseAction.self, links: [LinkedAction1.self]),
                                            ActionLinks(source: BaseAction2.self, links: [LinkedAction1.self])])
    XCTAssertEqual(actionLinker.links.count, 2)
    XCTAssertEqual(actionLinker.links[String(reflecting:BaseAction.self)]!.count, 1)
    XCTAssertEqual(actionLinker.links[String(reflecting:BaseAction2.self)]!.count, 1)
  }
  
  func testCreationTwoSameSourceActionOneLink() {
    let actionLinker = ActionLinker(links: [ActionLinks(source: BaseAction.self, links: [LinkedAction1.self]),
                                            ActionLinks(source: BaseAction.self, links: [LinkedAction2.self])])
    XCTAssertEqual(actionLinker.links.count, 1)
    XCTAssertEqual(actionLinker.links[String(reflecting:BaseAction.self)]!.count, 2)
  }
  
//MARK SyncAction
  
  func testNoChaining() {
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [], dependencies: EmptySideEffectDependencyContainer.self, links: [])
    _ = store.addListener { expectation.fulfill() }
    store.dispatch(BaseAction())
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      
      XCTAssertEqual(newState.int, 20)
    }
  }
  
  func testOneChain() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [],
                                            dependencies: EmptySideEffectDependencyContainer.self,
                                            links: [ActionLinks(source: BaseAction.self, links: [LinkedAction1.self])])
    _ = store.addListener {
      count += 1
      if count == 2 {
        expectation.fulfill()
      }
    }
    
    store.dispatch(BaseAction())
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertNotEqual(newState.int, 20)
      XCTAssertEqual(newState.int, 10)
    }
  }
  
  func testOneChainDoubleLength() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [],
                                            dependencies: EmptySideEffectDependencyContainer.self,
                                            links: [ActionLinks(source: BaseAction.self,
                                                                links: [LinkedAction1.self, LinkedAction1.self])])
    _ = store.addListener {
      count += 1
      if count == 3 {
        expectation.fulfill()
      }
    }
    
    store.dispatch(BaseAction())
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertNotEqual(newState.int, 20)
      XCTAssertNotEqual(newState.int, 10)
      XCTAssertEqual(newState.int, 5)
    }
  }
  
  func testOneChainWithTwoLinks() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [],
                                            dependencies: EmptySideEffectDependencyContainer.self,
                                            links: [ActionLinks(source: BaseAction.self, links: [LinkedAction1.self]),
                                                    ActionLinks(source: BaseAction.self, links: [LinkedAction1.self])])
    _ = store.addListener {
      count += 1
      if count == 3 {
        expectation.fulfill()
      }
    }
    
    store.dispatch(BaseAction())
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertNotEqual(newState.int, 20)
      XCTAssertNotEqual(newState.int, 10)
      XCTAssertEqual(newState.int, 5)
    }
  }
  
  func testTwoChains() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [],
                                            dependencies: EmptySideEffectDependencyContainer.self,
                                            links: [ActionLinks(source: BaseAction.self, links: [LinkedAction1.self]),
                                                    ActionLinks(source: BaseAction2.self, links: [LinkedAction1.self])])
    _ = store.addListener {
      count += 1
      if count == 2 {
        expectation.fulfill()
      }
    }
    
    store.dispatch(BaseAction())
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      
      XCTAssertNotEqual(newState.int, 20)
      XCTAssertEqual(newState.int, 10)
      
      //Chain 2
      let expectation2 = self.expectation(description: "Store listener 2")
      _ = store.addListener {
        if count == 4 {
          expectation2.fulfill()
        }
      }
      store.dispatch(BaseAction2())
      self.waitForExpectations(timeout: 2.0) { (err: Error?) in
        let newState = store.state
        
        XCTAssertNotEqual(newState.int, 10)
        XCTAssertEqual(newState.int, 5)
      }
    }
  }
  
  func testOneChainFailableActionSuccess() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [],
                                            dependencies: EmptySideEffectDependencyContainer.self,
                                            links: [ActionLinks(source: BaseAction2.self, links: [LinkedAction3.self])])
    _ = store.addListener {
      count += 1
      if count == 2 {
        expectation.fulfill()
      }
    }
    
    store.dispatch(BaseAction2())
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertNotEqual(newState.int, 20)
      XCTAssertEqual(newState.int, 100)
    }
  }
  
  func testOneChainFailableActionFailure() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [],
                                            dependencies: EmptySideEffectDependencyContainer.self,
                                            links: [ActionLinks(source: BaseAction.self, links: [LinkedAction3.self])])
    _ = store.addListener {
      count += 1
      if count == 1 {
        expectation.fulfill()
      }
    }
    
    store.dispatch(BaseAction())
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertEqual(newState.int, 20)
      XCTAssertNotEqual(newState.int, 100)
    }
  }
  
//MARK AsyncActions
  
  func testAsyncCompleted() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [],
                                            dependencies: EmptySideEffectDependencyContainer.self,
                                            links: [ActionLinks(source: BaseAsyncAction.self, links: [LinkedAction4.self])])
    _ = store.addListener {
      count += 1
      if count == 2 {
        expectation.fulfill()
      }
    }
    
    var baseAsyncAction = BaseAsyncAction(payload: 10).completedAction(payload: 100)
    baseAsyncAction.invokedCompletedClosure = {
      count += 1
    }
    baseAsyncAction.invokedFailedClosure = {
      count += 1
    }
    
    store.dispatch(baseAsyncAction)
    
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertNotEqual(newState.int, 100)
      XCTAssertEqual(newState.int, 10)
    }
  }
  
  func testAsyncFailed() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")
    
    let store = Store<ActionLinkerAppState>(middleware: [],
                                            dependencies: EmptySideEffectDependencyContainer.self,
                                            links: [ActionLinks(source: BaseAsyncAction.self, links: [LinkedAction5.self])])
    _ = store.addListener {
      count += 1
      if count == 2 {
        expectation.fulfill()
      }
    }
    
    var baseAsyncAction = BaseAsyncAction(payload: 10).failedAction(payload: -100)
    baseAsyncAction.invokedCompletedClosure = {
      count += 1
    }
    baseAsyncAction.invokedFailedClosure = {
      count += 1
    }
    
    store.dispatch(baseAsyncAction)
    
    XCTAssertTrue(true)
    
    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertNotEqual(newState.int, -100)
      XCTAssertEqual(newState.int, 10)
    }
  }
  
}

//MARK Mocking
struct ActionLinkerAppState: State {
  var int: Int = 0
}

struct BaseAction: Action {
  func updatedState(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int = 20
    return newState
  }
}

struct BaseAction2: Action {
  func updatedState(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int = 10
    return newState
  }
}

struct LinkedAction1: LinkeableAction {
  init() {
    
  }
  
  init?(oldState: State, newState: State, sourceAction: Action) {
    self = LinkedAction1()
  }
  
  func updatedState(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int = newState.int/2
    return newState
  }
}

struct LinkedAction2: LinkeableAction {
  init() {
    
  }
  
  init?(oldState: State, newState: State, sourceAction: Action) {
    self = LinkedAction2()
  }
  
  func updatedState(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int = newState.int*2
    return newState
  }
  
}

struct LinkedAction3: LinkeableAction {
  init() {
    
  }
  
  init?(oldState: State, newState: State, sourceAction: Action) {
    let currentState = newState as! ActionLinkerAppState
    if currentState.int <= 10 {
      self = LinkedAction3()
      return
    }
    return nil
  }
  
  func updatedState(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int = 100
    return newState
  }
}

//MARK Mocking for the async testing

fileprivate struct BaseAsyncAction: AsyncAction {

  public init(payload: Int) {
    self.loadingPayload = payload
    self.failedPayload = nil
    self.completedPayload = nil
    self.state = .loading
  }
  
  typealias LoadingPayload = Int
  typealias CompletedPayload = Int
  typealias FailedPayload = Int
  
  /// The loading payload of the action
  public var loadingPayload: Int
  public var failedPayload: Int?
  public var completedPayload: Int?

  /// The state of the action
  public var state: AsyncActionState

  var invokedLoadingClosure: () -> () = { _ in }
  var invokedCompletedClosure: () -> () = { _ in }
  var invokedFailedClosure: () -> () = { _ in }
  
  func updatedStateForLoading(currentState: State) -> State {
    self.invokedLoadingClosure()
    return currentState
  }

  func updatedStateForCompleted(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int = 100
    self.invokedCompletedClosure()
    return newState
  }
  
  func updatedStateForFailed(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int = -100
    self.invokedFailedClosure()
    return newState
  }
}

struct LinkedAction4: LinkeableAction {
  init() {
    
  }
  
  init?(oldState: State, newState: State, sourceAction: Action) {
    guard let source = sourceAction as? BaseAsyncAction else {
      return nil
    }
    
    if source.state == .completed {
      self = LinkedAction4()
      return
    }
    return nil
  }
  
  func updatedState(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int /= 10
    return newState
  }
}

struct LinkedAction5: LinkeableAction {
  init() {
    
  }
  
  init?(oldState: State, newState: State, sourceAction: Action) {
    guard let source = sourceAction as? BaseAsyncAction else {
      return nil
    }
    
    if source.state == .failed {
      self = LinkedAction5()
      return
    }
    return nil
  }

  func updatedState(currentState: State) -> State {
    var newState = currentState as! ActionLinkerAppState
    newState.int /= -10
    return newState
  }
}