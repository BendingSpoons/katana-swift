//
//  SideEffectTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana

class SideEffectTests: QuickSpec {
  override func spec() {
    describe("The Store") {
      var store: Store<AppState, TestDependenciesContainer>!
      
      beforeEach {
        store = Store<AppState, TestDependenciesContainer>()
      }
      
      describe("when managing a side effect") {
        it("invokes the side effect") {
          var invoked = false
          
          let sideEffect = SpySideEffect(delay: 0) { _ in invoked = true }
          
          waitUntil { done in
            store
              .dispatch(sideEffect)
              .then { done() }
          }
          
          expect(invoked) == true
        }
        
        it("invokes the side effect with the same dependencies container") {
          var firstDependenciesContainer: SideEffectDependencyContainer?
          var secondDependenciesContainer: SideEffectDependencyContainer?
          
          let sideEffect1 = SpySideEffect(delay: 0) { context in firstDependenciesContainer = context.dependencies }
          let sideEffect2 = SpySideEffect(delay: 0) { context in secondDependenciesContainer = context.dependencies }
          
          waitUntil(timeout: 10) { done in
            store
              .dispatch(sideEffect1)
              .thenDispatch(sideEffect2)
              .then { done() }
          }
          
          expect(firstDependenciesContainer) === secondDependenciesContainer
        }
        
        it("invokes side effects in the proper order, waiting for results") {
          var invocationResults: [String] = []
          
          let sideEffect1 = SpySideEffect(delay: 3) { context in invocationResults.append("1") }
          let sideEffect2 = SpySideEffect(delay: 1) { context in invocationResults.append("2") }
          let sideEffect3 = SpySideEffect(delay: 0) { context in invocationResults.append("3") }
          
          waitUntil(timeout: 10) { done in
            store.dispatch(sideEffect1).thenDispatch(sideEffect2).thenDispatch(sideEffect3).then { done() }
          }
          
          expect(invocationResults) == ["1", "2", "3"]
        }
        
        it("allows to invoke side effects from side effects") {
          var invocationResults: [String] = []
          
          let sideEffect1 = SpySideEffect(delay: 3) { context in
            invocationResults.append("1")
          }
          
          let sideEffect2 = SpySideEffect(delay: 1) { context in
            try await(context.dispatch(sideEffect1))
            invocationResults.append("2")
          }
          
          let sideEffect3 = SpySideEffect(delay: 0) { context in
            invocationResults.append("3")
          }
          
          waitUntil(timeout: 10) { done in
            store.dispatch(sideEffect2)
              .thenDispatch(sideEffect3)
              .then { done() }
          }
          
          expect(invocationResults) == ["1", "2", "3"]
        }
        
        it("correctly mixes store updater and side effects") {
          let todo = Todo(title: "title", id: "id")
          let user = User(username: "username")
          
          var step1State: AppState?
          var step2State: AppState?
          
          let sideEffect1 = SpySideEffect(delay: 0) { context in
            step1State = context.getState()
          }
          
          let sideEffect2 = SpySideEffect(delay: 0) { context in
            step2State = context.getState()
          }
          
          let addTodo = AddTodo(todo: todo)
          let addUser = AddUser(user: user)
          
          waitUntil(timeout: 10) { done in
            store
              .dispatch(addTodo)
              .thenDispatch(sideEffect1)
              .thenDispatch(addUser)
              .thenDispatch(sideEffect2)
              .then { done() }
          }
          
          expect(step1State?.todo.todos.count) == 1
          expect(step1State?.user.users.count) == 0
          expect(step1State?.todo.todos.first) == todo
          
          expect(step2State?.todo.todos.count) == 1
          expect(step2State?.user.users.count) == 1
          expect(step2State?.todo.todos.first) == todo
          expect(step2State?.user.users.first) == user
        }
        
        it("keeps getState updated within the side effect") {
          let todo = Todo(title: "title", id: "id")
          var firstState: AppState?
          var secondState: AppState?
          
          let sideEffect = SideEffectWithBlock { context in
            firstState = context.getState()
            try await(context.dispatch(AddTodo(todo: todo)))
            secondState = context.getState()
          }
          
          waitUntil(timeout: 10) { done in
            store.dispatch(sideEffect).then { done() }
          }
          
          expect(firstState?.todo.todos.count) == 0
          expect(secondState?.todo.todos.count) == 1
          expect(secondState?.todo.todos.first) == todo
        }
        
        it("propagates errors") {
          let sideEffect = SideEffectWithBlock { context in
            throw NSError(domain: "Test error", code: -1, userInfo: nil)
          }
          var rejectionError: Error?
          store.dispatch(sideEffect).then {
            fail("Promise should be rejected")
          }.catch { error in
            rejectionError = error
          }
          expect(rejectionError).toEventuallyNot(beNil())
        }
        
        it("propagates error when using middleware") {
          let middleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { dispatchable in
                next(dispatchable)
              }
            }
          }
          
          let interceptorFromMiddleware = middlewareToInterceptor(middleware)
          store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptorFromMiddleware])
          
          let sideEffect = SideEffectWithBlock { context in
            throw NSError(domain: "Test error", code: -1, userInfo: nil)
          }
          var rejectionError: Error?
          store.dispatch(sideEffect).then {
            fail("Promise should be rejected")
            }.catch { error in
              rejectionError = error
          }
          expect(rejectionError).toEventuallyNot(beNil())
        }
        
        it("retries dispatched actions") {
          store = Store<AppState, TestDependenciesContainer>()
          
          /// This sideEffect will fail the first time, but it will succeed if retried
          struct RetryMe: SideEffect {
            func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws {
              try context.awaitDispatch(AddTodo(todo: Todo(title: "test", id: "test")))
              if context.getState().todo.todos.count < 2 {
                throw NSError(domain: "Test error", code: -1, userInfo: nil)
              }
            }
          }
          
          store.dispatch(RetryMe())
            .retry(2)
            .catch { _ in fail("Retry should succeed") }
        }
      }
    }
  }
}

private struct SpySideEffect: TestSideEffect {
  var delay: TimeInterval
  var invokationClosure: (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> Void

  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws {
    if delay != 0 {
      try await(context.dependencies.delay(of: self.delay))
    }
    
    try invokationClosure(context)
  }
}

private struct SideEffectWithBlock: TestSideEffect {
  var block: (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> Void
  
  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws {
    try block(context)
  }
}

private struct AddTodo: TestStateUpdater {
  let todo: Todo
  
  func updateState(_ state: inout AppState) {
    state.todo.todos.append(self.todo)
  }
}

private struct AddUser: TestStateUpdater {
  let user: User
  
  func updateState(_ state: inout AppState) {
    state.user.users.append(self.user)
  }
}
