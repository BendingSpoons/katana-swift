//
//  StateUpdaterTests.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Quick
import Nimble
@testable import Katana

class StateUpdaterTests: QuickSpec {
  override func spec() {
    describe("The Store") {
      var store: Store<AppState, TestDependenciesContainer>!
      
      beforeEach {
        store = Store<AppState, TestDependenciesContainer>()
      }
      
      describe("when managing a state update") {
        it("is able to update the state") {

          let todo = Todo(title: "test", id: "ABC")

          expect(store.isReady).toEventually(beTruthy())

          waitUntil { done in
            store
              .dispatch(AddTodo(todo: todo))
              .then {
                expect(store.state.todo.todos.count) == 1
                expect(store.state.todo.todos.first) == todo
                done()
              }
          }
        }
        
        it("dispatches state updaters serially when using promises") {
          
          let todo = Todo(title: "test", id: "ABC")
          let user = User(username: "the_username")
          
          expect(store.isReady).toEventually(beTruthy())
          
          waitUntil { done in
            store
              .dispatch(AddTodo(todo: todo))
              .then {
                expect(store.state.todo.todos.count) == 1
                expect(store.state.todo.todos.first) == todo
                expect(store.state.user.users.count) == 0
              }
              .thenDispatch(AddUser(user: user))
              .then {
                expect(store.state.todo.todos.count) == 1
                expect(store.state.todo.todos.first) == todo
                expect(store.state.user.users.count) == 1
                expect(store.state.user.users.first) == user
                done()
              }
          }
        }
        
        it("dispatches state updaters serially") {
          let todo1 = Todo(title: "test", id: "ABC")
          let todo2 = Todo(title: "test1", id: "DEF")
          let todo3 = Todo(title: "test2", id: "GHI")
          
          expect(store.isReady).toEventually(beTruthy())
          
          store.dispatch(AddTodoWithDelay(todo: todo1, waitingTime: 3))
          store.dispatch(AddTodoWithDelay(todo: todo2, waitingTime: 2))
          store.dispatch(AddTodoWithDelay(todo: todo3, waitingTime: 0))
          
          expect(store.state.todo.todos.count).toEventually(be(3), timeout: 100)
          expect(store.state.todo.todos) == [todo1, todo2, todo3]
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

private struct AddUser: TestStateUpdater {
  let user: User
  
  func updateState(_ state: inout AppState) {
    state.user.users.append(self.user)
  }
}

private struct AddTodoWithDelay: TestStateUpdater {
  let todo: Todo
  let waitingTime: TimeInterval
  
  func updateState(_ state: inout AppState) {
    // Note: this is just for testing, never do things like this in real apps
    Thread.sleep(forTimeInterval: self.waitingTime)
    state.todo.todos.append(self.todo)
  }
}
