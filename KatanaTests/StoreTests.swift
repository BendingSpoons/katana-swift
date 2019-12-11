//
//  StoreTests.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana

class StoreTest: QuickSpec {
  override func spec() {
    describe("The Store") {
      var store: Store<AppState, TestDependenciesContainer>!
      
      beforeEach {
        store = Store<AppState, TestDependenciesContainer>()
      }
      
      it("initializes the state as empty by default") {
        expect(store.isReady).toEventually(beTruthy())
        expect(store.state) == AppState()
      }
      
      describe("when working with listeners") {
        it("invokes the listeners") {
          
          var listenerState: AppState?
          let todo = Todo(title: "title", id: "id")
          
          _ = store.addListener {
            listenerState = store.state
          }
          
          waitUntil { done in
            store.dispatch(AddTodo(todo: todo)).then {
              expect(listenerState).toNot(beNil())
              expect(listenerState?.todo.todos.first) == todo
              expect(listenerState?.todo.todos.count) == 1
              
              done()
            }
          }
        }
        
        it("allows to remove listeners") {
          var firstState: AppState? = nil
          var secondState: AppState? = nil
          var thirdState: AppState? = nil
          let todo1 = Todo(title: "title1", id: "id1")
          let todo2 = Todo(title: "title2", id: "id2")
          
          let unsubscribe = store.addListener {
            if secondState != nil {
              thirdState = store.state
            } else if firstState != nil {
              secondState = store.state
              
            } else {
              firstState = store.state
            }
          }
          
          waitUntil { done in
            store
              .dispatch(AddTodo(todo: todo1))
              .then { unsubscribe() }
              .thenDispatch(AddTodo(todo: todo2))
              .then {
                expect(firstState).toNot(beNil())
                expect(secondState).toNot(beNil())
                expect(thirdState).to(beNil())
                
                expect(secondState?.todo.todos.first) == todo1
                expect(secondState?.todo.todos.count) == 1
                
                expect(store.state.todo.todos) == [todo1, todo2]
                
                done()
            }
          }
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
