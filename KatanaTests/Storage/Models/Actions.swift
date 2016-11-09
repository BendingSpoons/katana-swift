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
  
  public static func updatedState(currentState: State, action: AddTodoAction) -> State {
    guard var s = currentState as? AppState else { return currentState }
    
    let todo = Todo(title: action.title, id: UUID().uuidString)
    s.todo.todos = s.todo.todos + [todo]
    
    return s
  }
  
  public static func == (lhs: AddTodoAction, rhs: AddTodoAction) -> Bool {
    return lhs.title == rhs.title
  }
}

struct RemoveTodoAction: Action {
  let id: String
  
  static func updatedState(currentState: State, action: RemoveTodoAction) -> State {
    guard var s = currentState as? AppState else { return currentState }
    
    let todos = s.todo.todos.filter { $0.id != action.id }
    s.todo.todos = todos
    
    return s
  }
}

struct SyncAddTodoAction: SyncAction {
  var payload: String

  static func updatedState(currentState: State, action: SyncAddTodoAction) -> State {
    guard var state = currentState as? AppState else {
      fatalError()
    }
    
    let todo = Todo(title: action.payload, id: UUID().uuidString)
    state.todo.todos = state.todo.todos + [todo]
    return state
  }
}

struct SpyActionWithSideEffect: ActionWithSideEffect {
  typealias ActionWithSideEffectCallback = (
    _ action: SpyActionWithSideEffect,
    _ state: State,
    _ dispatch: @escaping StoreDispatch,
    _ dependencies: SideEffectDependencyContainer) -> Void
  
  var sideEffectInvokedClosure: ActionWithSideEffectCallback?
  var updatedInvokedClosure: (() -> Void)?
  
  public static func updatedState(currentState: State, action: SpyActionWithSideEffect) -> State {
    action.updatedInvokedClosure?()
    return currentState
  }
  
  static func sideEffect(action: SpyActionWithSideEffect,
                         state: State,
                         dispatch: @escaping StoreDispatch,
                         dependencies: SideEffectDependencyContainer
    ) {
    action.sideEffectInvokedClosure?(action, state, dispatch, dependencies)
  }
}
