//
//  StoreMiddlewareTests.swift
//  KatanaTests
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana
import Hydra

class StoreInterceptorsTests: QuickSpec {
  override func spec() {
    describe("The Store") {
      describe("when dealing with state updater") {
        it("invokes the interceptors") {
          var dispatchedStateUpdater: AddTodo?
          var stateBefore: AppState?
          var stateAfter: AppState?

          let interceptor: StoreInterceptor = { context in
            return { next in
              return { stateUpdater in
                dispatchedStateUpdater = stateUpdater as? AddTodo
                stateBefore = context.getAnyState() as? AppState
                try next(stateUpdater)
                stateAfter = context.getAnyState() as? AppState
              }
            }
          }

          let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
          expect(store.isReady).toEventually(beTrue())

          store.dispatch(AddTodo(todo: Todo(title: "test", id: "id")))
          expect(dispatchedStateUpdater).toEventuallyNot(beNil())
          expect(stateBefore?.todo.todos.count).toEventually(be(0))
          expect(stateAfter?.todo.todos.count).toEventually(be(1))
        }

        it("invokes the middleware in the proper order") {
          var invokationOrder: [String] = []

          let firstInterceptor: StoreInterceptor = { context in
            return { next in
              return { stateUpdater in
                invokationOrder.append("first")
                try next(stateUpdater)
              }
            }
          }

          let secondInterceptor: StoreInterceptor = { context in
            return { next in
              return { stateUpdater in
                invokationOrder.append("second")
                try next(stateUpdater)
              }
            }
          }

          let store = Store<AppState, TestDependenciesContainer>(interceptors: [firstInterceptor, secondInterceptor])
          store.dispatch(AddTodo(todo: Todo(title: "test", id: "id")))

          expect(store.isReady).toEventually(beTrue())
          expect(invokationOrder).toEventually(equal(["first", "second"]))
        }

        it("allows the middleware to block the propagation") {
          var dispatchedStateUpdater: AddTodo?

          let interceptor: StoreInterceptor = { context in
            return { next in
              return { stateUpdater in
                dispatchedStateUpdater = stateUpdater as? AddTodo
                throw StoreInterceptorChainBlocked()
              }
            }
          }

          let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
          expect(store.isReady).toEventually(beTrue())

          store.dispatch(AddTodo(todo: Todo(title: "test", id: "id")))
          expect(dispatchedStateUpdater).toEventuallyNot(beNil())
          expect(store.state.todo.todos.count).toEventually(be(0))
        }
      }
      
      describe("when dealing with side effect") {
        it("invokes the middleware") {
          var dispatchedSideEffect: DelaySideEffect?
          var stateBefore: AppState?
          var stateAfter: AppState?

          let interceptor: StoreInterceptor = { context in
            return { next in
              return { sideEffect in
                dispatchedSideEffect = sideEffect as? DelaySideEffect
                stateBefore = context.getAnyState() as? AppState
                try next(sideEffect)
                stateAfter = context.getAnyState() as? AppState
              }
            }
          }

          let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
          expect(store.isReady).toEventually(beTrue())

          store.dispatch(DelaySideEffect())
          expect(dispatchedSideEffect).toEventuallyNot(beNil())
          expect(stateBefore?.todo.todos.count).toEventually(equal(0))
          expect(stateAfter?.todo.todos.count).toEventually(equal(0), timeout: 200)
        }

        it("invokes the middleware in the proper order") {
          var invokationOrder: [String] = []

          let firstInterceptor: StoreInterceptor = { context in
            return { next in
              return { sideEffect in
                invokationOrder.append("first")
                try next(sideEffect)
              }
            }
          }

          let secondInterceptor: StoreInterceptor = { context in
            return { next in
              return { sideEffect in
                invokationOrder.append("second")
                try next(sideEffect)
              }
            }
          }

          let store = Store<AppState, TestDependenciesContainer>(interceptors: [firstInterceptor, secondInterceptor])
          store.dispatch(DelaySideEffect())

          expect(store.isReady).toEventually(beTrue())
          expect(invokationOrder).toEventually(equal(["first", "second"]))
        }
        
        it("allows the middleware to block the propagation") {
          var dispatchedStateUpdater: SideEffectWithBlock?
          var invoked = false
          
          let interceptor: StoreInterceptor = { context in
            return { next in
              return { sideEffect in
                dispatchedStateUpdater = sideEffect as? SideEffectWithBlock
                throw StoreInterceptorChainBlocked()
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
          expect(store.isReady).toEventually(beTrue())
          
          let sideEffect = SideEffectWithBlock { _ in
            invoked = true
          }
          
          store.dispatch(sideEffect)
          expect(dispatchedStateUpdater).toEventuallyNot(beNil())
          expect(invoked).toEventually(beFalse())
        }
        
        it("invokes the middleware with returning side effects") {
          let todo = Todo(title: "title", id: "id")
          var dispatchedSideEffect: SideEffectWithBlock?
          var stateBefore: AppState?
          var stateAfter: AppState?
          var returnedState: AppState?

          let interceptor: StoreInterceptor = { context in
            return { next in
              return { sideEffect in
                if dispatchedSideEffect == nil {
                  dispatchedSideEffect = sideEffect as? SideEffectWithBlock
                  try await(context.dispatch(AddTodo(todo: todo)))
                }
                stateBefore = context.getAnyState() as? AppState
                try next(sideEffect)
                stateAfter = context.getAnyState() as? AppState
              }
            }
          }

          let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
          expect(store.isReady).toEventually(beTrue())

          store.dispatch(SideEffectWithBlock(block: { context in
            try await(context.dispatch(AddTodo(todo: todo)))
          })).then { returnedState = $0 }

          expect(dispatchedSideEffect).toEventuallyNot(beNil())
          expect(stateBefore?.todo.todos.count).toEventually(equal(0))
          expect(stateAfter?.todo.todos.count).toEventually(equal(2), timeout: 200)
          expect(returnedState?.todo.todos).toEventually(equal([todo, todo]))
        }
      }
    }
  }
}

private struct AddTodo: TestStateUpdater {
  let todo: Todo
  
  func updateState(_ state: inout AppState) {
    state.todo.todos.append(self.todo)
  }
}

private struct DelaySideEffect: TestSideEffect {
  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws {
    try await(context.dependencies.delay(of: 1))
  }
}

private struct SideEffectWithBlock: ReturningTestSideEffect {
  var block: (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> Void
  
  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> AppState {
    try block(context)
    return context.getState()
  }
}

struct StoreInterceptorChainBlocked: Error {}
