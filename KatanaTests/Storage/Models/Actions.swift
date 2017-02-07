//
//  Actions.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
@testable import Katana

public struct AddTodoAction: Action, Equatable {
  public let title: String

  public func updatedState(currentState: State) -> State {
    guard var s = currentState as? AppState else { return currentState }

    let todo = Todo(title: self.title, id: UUID().uuidString)
    s.todo.todos = s.todo.todos + [todo]

    return s
  }

  public static func == (lhs: AddTodoAction, rhs: AddTodoAction) -> Bool {
    return lhs.title == rhs.title
  }
}

struct RemoveTodoAction: Action {
  let id: String

  func updatedState(currentState: State) -> State {
    guard var s = currentState as? AppState else { return currentState }

    let todos = s.todo.todos.filter { $0.id != self.id }
    s.todo.todos = todos

    return s
  }
}

struct SyncAddTodoAction: Action {
  var payload: String

  func updatedState(currentState: State) -> State {
    guard var state = currentState as? AppState else {
      fatalError()
    }

    let todo = Todo(title: self.payload, id: UUID().uuidString)
    state.todo.todos = state.todo.todos + [todo]
    return state
  }
}

struct SpyActionWithSideEffect: ActionWithSideEffect {
  typealias ActionWithSideEffectCallback = (
    _ currentState: State,
    _ previousState: State,
    _ dispatch: @escaping StoreDispatch,
    _ dependencies: SideEffectDependencyContainer) -> ()

  var sideEffectInvokedClosure: ActionWithSideEffectCallback?
  var updatedInvokedClosure: (() -> ())?

  public func updatedState(currentState: State) -> State {
    self.updatedInvokedClosure?()
    return currentState
  }
  
  public func sideEffect(
    currentState: State,
    previousState: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer) {
    
    self.sideEffectInvokedClosure?(currentState, previousState, dispatch, dependencies)
  }
}
