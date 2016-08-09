//
//  reducers.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import ReKatana

enum TodoReducer: Reducer {
  static let initialState = TodoState(todos: [])

  static func reduce(action: Action, state: TodoState?) -> TodoState {
    guard let s = state else {
      return initialState
    }
    
    if let action = action as? AddTodoAction {
      return _reduce(action: action, state: s)
    
    } else if let action = action as? RemoveTodoAction {
      return _reduce(action: action, state: s)
    }
    
    return s
  }
  
  static func _reduce(action: AddTodoAction, state: TodoState) -> TodoState {
    let newTodo = Todo(title: action.title, id: NSUUID().uuidString)
    let todos = state.todos + [newTodo]
    return TodoState(todos: todos)
  }
  
  static func _reduce(action: RemoveTodoAction, state: TodoState) -> TodoState {
    let todos = state.todos.filter { $0.id != action.id }
    return TodoState(todos: todos)
  }
}

enum UserReducer: Reducer {
  static let initialState = UserState(users: [])
  static func reduce(action: Action, state: UserState?) -> UserState {
    return state ?? initialState
  }
}


enum AppReducer: Reducer {
  static func reduce(action: Action, state: AppState?) -> AppState {
    return AppState(
      todo: TodoReducer.reduce(action: action, state: state?.todo),
      user: UserReducer.reduce(action: action, state: state?.user)
    )
  }
}
