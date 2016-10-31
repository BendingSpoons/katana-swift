//
//  CompleteTodo.swift
//  Katana
//
//  Created by Luca Querella on 01/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct ToogleTodoCompletion: SyncAction {
  var payload: Int
  
  static func reduce(state: inout ToDoState, action: ToogleTodoCompletion) {
    state.todosCompleted[action.payload] = !state.todosCompleted[action.payload]
  }
}
