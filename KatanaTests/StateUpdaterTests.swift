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
      var store: Store<AppState>!
      
      beforeEach {
        store = Store<AppState>()
      }
      
      describe("when managing a state update") {
        it("is able to update the state") {
          
          let todo = Todo(title: "test", id: "ABC")
          
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
        
        it("dispatches state updaters serially") {
          
          let todo = Todo(title: "test", id: "ABC")
          let user = User(username: "the_username")
          
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
      }
    }
  }
}

struct AddTodo: TestStateUpdater {
  let todo: Todo
  
  func updatedState(_ state: inout AppState) {
    state.todo.todos.append(self.todo)
  }
}

struct AddUser: TestStateUpdater {
  let user: User
  
  func updatedState(_ state: inout AppState) {
    state.user.users.append(self.user)
  }
}
