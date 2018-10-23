//
//  StoreTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
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
            store.dispatch(AddTodo(todo: todo)).then { done() }
          }
          
          expect(listenerState).toNot(beNil())
          expect(listenerState?.todo.todos.first) == todo
          expect(listenerState?.todo.todos.count) == 1
        }
        
        it("allows to remove listeners") {
          var firstState: AppState? = nil
          var secondState: AppState? = nil
          let todo1 = Todo(title: "title1", id: "id1")
          let todo2 = Todo(title: "title2", id: "id2")
          
          let unsubscribe = store.addListener {
            if firstState != nil {
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
              .then { done() }
          }
          
          expect(firstState).toNot(beNil())
          expect(secondState).to(beNil())
          
          expect(firstState?.todo.todos.first) == todo1
          expect(firstState?.todo.todos.count) == 1

          expect(store.state.todo.todos) == [todo1, todo2]
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
