//
//  ActionLinkerTests.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import XCTest
@testable import Katana

fileprivate typealias ActionLinkerStore = Store<ActionLinkerAppState, EmptySideEffectDependencyContainer>

class LegacyActionLinkerTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: Creation tests
  func testReduceNothing() {
    let res = ActionLinker.reduceLinks(from: [])

    XCTAssertTrue(res.isEmpty)
  }

  func testReduceOneSourceActionOneLink() {
    let res = ActionLinker.reduceLinks(from: [
      ActionLinks(source: BaseAction.Twenty.self, links: [LinkedAction.Halve.self])
    ])

    XCTAssertEqual(res.count, 1)
    XCTAssertEqual(res[ActionLinker.stringName(for: BaseAction.Twenty.self)]!.count, 1)

  }

  func testCreationOneSourceActionTwoLinks() {
    let res = ActionLinker.reduceLinks(from: [
      ActionLinks(source: BaseAction.Twenty.self, links: [
        LinkedAction.Halve.self,
        LinkedAction.Halve.self,
      ])
    ])

    XCTAssertEqual(res.count, 1)
    XCTAssertEqual(res[ActionLinker.stringName(for: BaseAction.Twenty.self)]!.count, 2)
  }

  func testCreationTwoSourceActionOneLink() {
    let res = ActionLinker.reduceLinks(from: [
      ActionLinks(source: BaseAction.Twenty.self, links: [LinkedAction.Halve.self]),
      ActionLinks(source: BaseAction.Ten.self, links: [LinkedAction.Halve.self]),
    ])

    XCTAssertEqual(res.count, 2)
    XCTAssertEqual(res[ActionLinker.stringName(for: BaseAction.Twenty.self)]!.count, 1)
    XCTAssertEqual(res[ActionLinker.stringName(for: BaseAction.Ten.self)]!.count, 1)
  }

  func testCreationTwoSameSourceActionOneLink() {
    let res = ActionLinker.reduceLinks(from: [
      ActionLinks(source: BaseAction.Twenty.self, links: [LinkedAction.Halve.self]),
      ActionLinks(source: BaseAction.Twenty.self, links: [LinkedAction.DoubleUp.self]),
    ])

    XCTAssertEqual(res.count, 1)
    XCTAssertEqual(res[ActionLinker.stringName(for: BaseAction.Twenty.self)]!.count, 2)
  }

  // MARK: Action

  func testNoChaining() {
    let expectation = self.expectation(description: "Store listener")

    let store = ActionLinkerStore(interceptors: [
      ExpectationInterceptor(expectation: expectation).katanaInterceptor,
      middlewareToInterceptor(ActionLinker.middleware(for: [])),
    ])

    expectation.expectedFulfillmentCount = 1
    expectation.assertForOverFulfill = true
    store.dispatch(BaseAction.Twenty())

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(store.state.int, 20)
    }
  }

  func testOneChain() {
    let expectation = self.expectation(description: "Store listener")

    let linksArray = [
      ActionLinks(source: BaseAction.Twenty.self, links: [LinkedAction.Halve.self]),
    ]

    let store = ActionLinkerStore(interceptors: [
      ExpectationInterceptor(expectation: expectation).katanaInterceptor,
      middlewareToInterceptor(ActionLinker.middleware(for: linksArray)),
    ])

    expectation.expectedFulfillmentCount = 2
    expectation.assertForOverFulfill = true
    store.dispatch(BaseAction.Twenty())

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(store.state.int, 10)
    }
  }

  func testOneChainDoubleLength() {
    let expectation = self.expectation(description: "Store listener")

    let linksArray = [
      ActionLinks(source: BaseAction.Twenty.self, links: [
        LinkedAction.Halve.self,
        LinkedAction.Halve.self,
      ]),
    ]

    let store = ActionLinkerStore(interceptors: [
      ExpectationInterceptor(expectation: expectation).katanaInterceptor,
      middlewareToInterceptor(ActionLinker.middleware(for: linksArray)),
    ])

    expectation.expectedFulfillmentCount = 3
    expectation.assertForOverFulfill = true
    store.dispatch(BaseAction.Twenty())

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(store.state.int, 5)
    }
  }

  func testOneChainWithTwoLinks() {
    let expectation = self.expectation(description: "Store listener")

    let linksArray = [
      ActionLinks(source: BaseAction.Twenty.self, links: [LinkedAction.DoubleUp.self]),
      ActionLinks(source: BaseAction.Ten.self, links: [LinkedAction.Halve.self]),
    ]

    let store = ActionLinkerStore(interceptors: [
      ExpectationInterceptor(expectation: expectation).katanaInterceptor,
      middlewareToInterceptor(ActionLinker.middleware(for: linksArray)),
    ])

    expectation.expectedFulfillmentCount = 2
    expectation.assertForOverFulfill = true
    store.dispatch(BaseAction.Ten())

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(store.state.int, 5)
    }
  }

  func testOneChainFailableActionSuccess() {
    let expectation = self.expectation(description: "Store listener")

    let linksArray = [
      ActionLinks(source: BaseAction.Ten.self, links: [LinkedAction.Hundred.self]),
    ]

    let store = ActionLinkerStore(interceptors: [
      ExpectationInterceptor(expectation: expectation).katanaInterceptor,
      middlewareToInterceptor(ActionLinker.middleware(for: linksArray)),
    ])

    expectation.expectedFulfillmentCount = 2
    expectation.assertForOverFulfill = true
    store.dispatch(BaseAction.Ten())

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      XCTAssertEqual(store.state.int, 100)
    }
  }

  func testOneChainFailableActionFailure() {
    let expectation = self.expectation(description: "Store listener")

    let linksArray = [
      ActionLinks(source: BaseAction.Twenty.self, links: [LinkedAction.Hundred.self]),
    ]

    let store = ActionLinkerStore(interceptors: [
      ExpectationInterceptor(expectation: expectation).katanaInterceptor,
      middlewareToInterceptor(ActionLinker.middleware(for: linksArray)),
    ])

    expectation.expectedFulfillmentCount = 1
    expectation.assertForOverFulfill = true
    store.dispatch(BaseAction.Twenty())

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertEqual(store.state.int, 20)
    }
  }

  // MARK: AsyncAction

  func testAsyncCompleted() {
    var count = 0
    let expectation = self.expectation(description: "Store listener")

    let linksArray = [
      ActionLinks(source: BaseAsyncAction.self, links: [LinkedAction.Tenth.self]),
    ]

    let store = ActionLinkerStore(interceptors: [
      middlewareToInterceptor(ActionLinker.middleware(for: linksArray))
    ])

    var baseAsyncAction = BaseAsyncAction(payload: 10).completedAction {
      $0.completedPayload = 100
    }

    baseAsyncAction.invokedCompletedClosure = {
      count += 1
    }
    baseAsyncAction.invokedFailedClosure = {
      fatalError("It shouldn't happen")
    }

    store.dispatch(baseAsyncAction)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
      expectation.fulfill()
    })

    self.waitForExpectations(timeout: 1.0) { (err: Error?) in
      XCTAssertEqual(store.state.int, 10)
    }
  }

  func testAsyncFailed() {
    let expectation = self.expectation(description: "Store listener")

    let linksArray = [
      ActionLinks(source: BaseAsyncAction.self, links: [LinkedAction.NegativeTenth.self]),
    ]

    let store = ActionLinkerStore(interceptors: [
      ExpectationInterceptor(expectation: expectation).katanaInterceptor,
      middlewareToInterceptor(ActionLinker.middleware(for: linksArray)),
    ])

    var baseAsyncAction = BaseAsyncAction(payload: 10).failedAction {
      $0.failedPayload = -100
    }

    expectation.expectedFulfillmentCount = 2
    expectation.assertForOverFulfill = true
    store.dispatch(baseAsyncAction)

    self.waitForExpectations(timeout: 2.0) { (err: Error?) in
      let newState = store.state
      XCTAssertEqual(store.state.int, 10)
    }
  }
}

// MARK: Mocking
fileprivate struct ActionLinkerAppState: State {
  var int: Int = 0
}

fileprivate enum BaseAction {
  
  struct Twenty: Action {
    func updatedState(currentState: State) -> State {
      var newState = currentState as! ActionLinkerAppState
      newState.int = 20
      return newState
    }
  }
  
  fileprivate struct Ten: Action {
    func updatedState(currentState: State) -> State {
      var newState = currentState as! ActionLinkerAppState
      newState.int = 10
      return newState
    }
  }
}

fileprivate enum LinkedAction {
  
  fileprivate struct Halve: LinkeableAction {
    init() {
      
    }
    
    init?(oldState: State, newState: State, sourceAction: Action) {
      self = Halve()
    }
    
    func updatedState(currentState: State) -> State {
      var newState = currentState as! ActionLinkerAppState
      newState.int = newState.int / 2
      return newState
    }
  }
  
  fileprivate struct DoubleUp: LinkeableAction {
    init() {
      
    }
    
    init?(oldState: State, newState: State, sourceAction: Action) {
      self = DoubleUp()
    }
    
    func updatedState(currentState: State) -> State {
      var newState = currentState as! ActionLinkerAppState
      newState.int = newState.int * 2
      return newState
    }
    
  }
  
  struct Hundred: LinkeableAction {
    init() {
      
    }
    
    init?(oldState: State, newState: State, sourceAction: Action) {
      let currentState = newState as! ActionLinkerAppState
      if currentState.int <= 10 {
        self = Hundred()
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
}

// MARK: Mocking for the async testing

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

  var invokedLoadingClosure: () -> () = { }
  var invokedCompletedClosure: () -> () = { }
  var invokedFailedClosure: () -> () = { }

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

  public func updatedStateForProgress(currentState: State) -> State {
    return currentState
  }
}

fileprivate extension LinkedAction {
  
  struct Tenth: LinkeableAction {
    init() {
      
    }
    
    init?(oldState: State, newState: State, sourceAction: Action) {
      guard let source = sourceAction as? BaseAsyncAction else {
        return nil
      }
      
      if source.state == .completed {
        self = Tenth()
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
  
  fileprivate struct NegativeTenth: LinkeableAction {
    init() {
      
    }
    
    init?(oldState: State, newState: State, sourceAction: Action) {
      guard let source = sourceAction as? BaseAsyncAction else {
        return nil
      }
      
      if source.state == .failed {
        self = NegativeTenth()
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
}

// MARK: - Interceptor

fileprivate final class ExpectationInterceptor {
  let expectation: XCTestExpectation
  
  init(expectation: XCTestExpectation) {
    self.expectation = expectation
  }
  
  var katanaInterceptor: StoreInterceptor {
    return { context in
      return { next in
        return { [weak self] action in
          // count both successul and failing actions
          do {
            try next(action)
            self?.expectation.fulfill()
          } catch {
            self?.expectation.fulfill()
            throw error
          }
        }
      }
    }
  }
}
