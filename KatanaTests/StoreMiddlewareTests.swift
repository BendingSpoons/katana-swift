//
//  StoreMiddlewareTests.swift
//  KatanaTests
//
//  Created by Mauro Bolis on 22/10/2018.
//

import Foundation
import Quick
import Nimble
@testable import Katana

class StoreMiddlewareTests: QuickSpec {
  override func spec() {
    describe("The Store") {
      describe("when dealing with state updater") {
        
        it("invokes the middleware") {
          var dispatchedStateUpdater: AddTodo?
          var stateBefore: AppState?
          var stateAfter: AppState?
      
          let middleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { action in
                dispatchedStateUpdater = action as? AddTodo
                stateBefore = getState() as? AppState
                next(action)
                stateAfter = getState() as? AppState
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(middleware: [middleware])
          
          expect(store.isReady).toEventually(beTrue())
          
          store.dispatch(AddTodo(todo: Todo(title: "test", id: "id")))
          
          expect(dispatchedStateUpdater).toEventuallyNot(beNil())
          expect(stateBefore?.todo.todos.count).toEventually(be(0))
          expect(stateAfter?.todo.todos.count).toEventually(be(1))
        }
        
        it("invokes the middleware in the proper order") {
          var invokationOrder: [String] = []
          
          let firstMiddleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { action in
                invokationOrder.append("first")
                next(action)
              }
            }
          }
          
          let secondMiddleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { action in
                invokationOrder.append("second")
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(middleware: [firstMiddleware, secondMiddleware])
          store.dispatch(AddTodo(todo: Todo(title: "test", id: "id")))

          expect(store.isReady).toEventually(beTrue())
          expect(invokationOrder).toEventually(be(["first", "second"]))
        }
        
        it("allows the middleware to block the propagation") {
          var dispatchedStateUpdater: AddTodo?
          
          let middleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { action in
                dispatchedStateUpdater = action as? AddTodo
                // note: we are not calling next
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(middleware: [middleware])
          
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
          
          let middleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { action in
                dispatchedSideEffect = action as? DelaySideEffect
                stateBefore = getState() as? AppState
                next(action)
                stateAfter = getState() as? AppState
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(middleware: [middleware])
          
          expect(store.isReady).toEventually(beTrue())
          
          store.dispatch(DelaySideEffect())
          
          expect(dispatchedSideEffect).toEventuallyNot(beNil())
          expect(stateBefore?.todo.todos.count).toEventually(be(0))
          expect(stateAfter?.todo.todos.count).toEventually(be(0))
        }
        
        it("invokes the middleware in the proper order") {
          var invokationOrder: [String] = []
          
          let firstMiddleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { action in
                invokationOrder.append("first")
                next(action)
              }
            }
          }
          
          let secondMiddleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { action in
                invokationOrder.append("second")
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(middleware: [firstMiddleware, secondMiddleware])
          store.dispatch(DelaySideEffect())
          
          expect(store.isReady).toEventually(beTrue())
          expect(invokationOrder).toEventually(be(["first", "second"]))
        }
        
        it("allows the middleware to block the propagation") {
          var dispatchedStateUpdater: AddTodo?
          var invoked = false
          
          let middleware: StoreMiddleware = { getState, dispatch in
            return { next in
              return { action in
                dispatchedStateUpdater = action as? AddTodo
                // note: we are not calling next
              }
            }
          }
          
          let store = Store<AppState, TestDependenciesContainer>(middleware: [middleware])
          
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
  
  func updatedState(_ state: inout AppState) {
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
