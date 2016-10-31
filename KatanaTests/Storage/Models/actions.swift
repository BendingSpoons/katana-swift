//
//  File.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import Katana

public struct AddTodoAction: Action, Equatable {
  public let title: String
  
  public static func reduce(state: State, action: AddTodoAction) -> State {
    guard var s = state as? AppState else { return state }
    
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
  
  static func reduce(state: State, action: RemoveTodoAction) -> State {
    guard var s = state as? AppState else { return state }
    
    let todos = s.todo.todos.filter { $0.id != action.id }
    s.todo.todos = todos
    
    return s
  }
}

struct SyncAddTodoAction: SyncAction {
  var payload: String

  static func reduce(state: State, action: SyncAddTodoAction) -> State {
    guard var state = state as? AppState else {
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
  var reduceInvokedClosure: (() -> Void)?
  
  public static func reduce(state: State, action: SpyActionWithSideEffect) -> State {
    action.reduceInvokedClosure?()
    return state
  }
  
  static func sideEffect(action: SpyActionWithSideEffect,
                         state: State,
                         dispatch: @escaping StoreDispatch,
                         dependencies: SideEffectDependencyContainer
    ) {
    action.sideEffectInvokedClosure?(action, state, dispatch, dependencies)
  }
}
