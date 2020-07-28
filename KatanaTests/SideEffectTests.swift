//
//  SideEffectTests.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
import Hydra

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
              .then {
                expect(invoked) == true
                
                done()
            }
          }
        }
        
        it("invokes the side effect with the same dependencies container") {
          var firstDependenciesContainer: SideEffectDependencyContainer?
          var secondDependenciesContainer: SideEffectDependencyContainer?
          
          let sideEffect1 = SpySideEffect(delay: 0) { context in firstDependenciesContainer = context.dependencies }
          let sideEffect2 = SpySideEffect(delay: 0) { context in secondDependenciesContainer = context.dependencies }
          
          waitUntil(timeout: 10) { done in
            store
              .dispatch(sideEffect1)
              .then { store.dispatch(sideEffect2) }
              .then {
                expect(firstDependenciesContainer) === secondDependenciesContainer
                
                done()
            }
          }
          
        }
        
        it("invokes side effects in the proper order, waiting for results") {
          var invocationResults: [String] = []
          
          let sideEffect1 = SpySideEffect(delay: 3) { context in invocationResults.append("1") }
          let sideEffect2 = SpySideEffect(delay: 1) { context in invocationResults.append("2") }
          let sideEffect3 = SpySideEffect(delay: 0) { context in invocationResults.append("3") }
          
          waitUntil(timeout: 10) { done in
            store.dispatch(sideEffect1)
              .then { store.dispatch(sideEffect2) }
              .then { store.dispatch(sideEffect3) }
              .then {
                expect(invocationResults) == ["1", "2", "3"]
                done()
            }
          }
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
              .then { store.dispatch(sideEffect3) }
              .then {
                expect(invocationResults) == ["1", "2", "3"]
                done()
            }
          }
        }
        
        it("correctly mixes state updater and side effects") {
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
              .then { store.dispatch(sideEffect1) }
              .then { store.dispatch(addUser) }
              .then { store.dispatch(sideEffect2) }
              .then {
                expect(step1State?.todo.todos.count) == 1
                expect(step1State?.user.users.count) == 0
                expect(step1State?.todo.todos.first) == todo
                
                expect(step2State?.todo.todos.count) == 1
                expect(step2State?.user.users.count) == 1
                expect(step2State?.todo.todos.first) == todo
                expect(step2State?.user.users.first) == user
                
                done()
            }
          }
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
            store.dispatch(sideEffect).then { _ in
              expect(firstState?.todo.todos.count) == 0
              expect(secondState?.todo.todos.count) == 1
              expect(secondState?.todo.todos.first) == todo
              
              done()
            }
          }
        }
        
        it("propagates errors") {
          let sideEffect = SideEffectWithBlock { context in
            throw NSError(domain: "Test error", code: -1, userInfo: nil)
          }
          
          waitUntil(timeout: 10) { done in
            store.dispatch(sideEffect).then { _ in
              fail("Promise should be rejected")
            }.catch { error in
              done()
            }
          }
        }
        
        it("retries dispatched dispatchables") {
          store = Store<AppState, TestDependenciesContainer>()
          
          waitUntil(timeout: 10) { done in
            store.dispatch(RetryMe())
              .retry(2)
              .then { done() }
              .catch { _ in fail("Retry should succeed") }
          }
        }
      }
      
      describe("when managing a returning side effect") {
        it("returns the wanted value") {
          let returningSideEffect = LongOperation(input: 5)
          
          waitUntil(timeout: 10) { done in
            store.dispatch(returningSideEffect).then { (result: Int) in
              expect(result) == 10
              done()
            }
          }
        }
        
        it("returns the correct value when retrying") {
          let returningSideEffect = LongOperation(input: 5)
          
          waitUntil(timeout: 10) { done in
            store.dispatch(returningSideEffect)
              .then { (result: Int) in
                expect(result) == 10
                done()
            }
          }
        }
        
        it("can return values from the state around state updater invocation") {
          let todo: Todo = Todo(title: "title", id: "id")
          let returningSideEffect = SideEffectWithBlock(block: { context in
            try await(context.dispatch(AddTodo(todo: todo)))
          })
          
          waitUntil(timeout: 10) { done in
            store.dispatch(returningSideEffect).then { (result: AppState) in
              expect(result.todo.todos) == [todo]
              done()
            }
          }
        }
        
        it("can return values from inside other side effects") {
          let se = ReentrantReturningSideEffect(input: 5)
          
          waitUntil(timeout: 10) { done in
            store.dispatch(se).then { (result: Int) in
              expect(result) == 5 * 2 * 2
              done()
            }
          }
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

private struct SideEffectWithBlock: ReturningTestSideEffect {
  var block: (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> Void
  
  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> AppState {
    try block(context)
    return context.getState()
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

private struct LongOperation: ReturningSideEffect {
  let input: Int
  
  func sideEffect(_ context: AnySideEffectContext) throws -> Int {
    Thread.sleep(forTimeInterval: 1)
    return self.input * 2
  }
}

/// This sideEffect will fail the first time, but it will succeed if retried
private struct RetryMe: SideEffect {
  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws {
    try await(context.dispatch(AddTodo(todo: Todo(title: "test", id: "test"))))
    if context.getState().todo.todos.count < 2 {
      throw NSError(domain: "Test error", code: -1, userInfo: nil)
    }
  }
}

private struct FailingLongOperation: ReturningSideEffect {
  let input: Int
  
  func sideEffect(_ context: AnySideEffectContext) throws -> Int {
    guard let typedContext = context as? SideEffectContext<AppState, TestDependenciesContainer> else {
      fatalError()
    }

    let state = typedContext.getState()
    
    guard state.todo.todos.count >= 2 else {
      throw NSError(domain: "Retry!", code: -1, userInfo: nil)
    }
    
    try await(context.dispatch(AddTodo(todo: Todo(title: "New todo", id: UUID().uuidString))))
    
    Thread.sleep(forTimeInterval: 1)
    return self.input * 2
  }
}

private struct ReentrantReturningSideEffect: ReturningSideEffect {
  let input: Int
  
  func sideEffect(_ context: AnySideEffectContext) throws -> Int {
    let a = try await(context.dispatch(LongOperation(input: self.input)))
    return a * 2
  }
}
