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
