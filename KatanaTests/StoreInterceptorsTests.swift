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
          var invocationOrder: [String] = []
          
          let firstInterceptor: StoreInterceptor = { context in
            return { next in
              return { stateUpdater in
                invocationOrder.append("first")
                try next(stateUpdater)
              }
            }
          }
          
          let secondInterceptor: StoreInterceptor = { context in
            return { next in
              return { stateUpdater in
                invocationOrder.append("second")
                try next(stateUpdater)
              }
            }
          }
          
          let thirdInterceptor: StoreInterceptor = { context in
            return { next in
              return { stateUpdater in
                invocationOrder.append("third")
                try next(stateUpdater)
              }
            }
          }
          
          let fourthInterceptor: StoreInterceptor = { context in
            return { next in
              return { stateUpdater in
                invocationOrder.append("fourth")
                try next(stateUpdater)
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(interceptors: [
            firstInterceptor,
            secondInterceptor,
            thirdInterceptor,
            fourthInterceptor,
          ])
          store.dispatch(AddTodo(todo: Todo(title: "test", id: "id")))

          expect(store.isReady).toEventually(beTrue())
          expect(invocationOrder).toEventually(equal([
            "first",
            "second",
            "third",
            "fourth",
          ]))
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
          var invocationOrder: [String] = []
          
          let firstInterceptor: StoreInterceptor = { context in
            return { next in
              return { sideEffect in
                invocationOrder.append("first")
                try next(sideEffect)
              }
            }
          }
          
          let secondInterceptor: StoreInterceptor = { context in
            return { next in
              return { sideEffect in
                invocationOrder.append("second")
                try next(sideEffect)
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(interceptors: [firstInterceptor, secondInterceptor])
          store.dispatch(DelaySideEffect())
          
          expect(store.isReady).toEventually(beTrue())
          expect(invocationOrder).toEventually(equal(["first", "second"]))
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

private struct SideEffectWithBlock: TestSideEffect {
  var block: (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> Void
  
  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws {
    try block(context)
  }
}

struct StoreInterceptorChainBlocked: Error {}
