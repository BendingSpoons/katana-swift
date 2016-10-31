//
//  DownloadPhotos.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct RemoveTodo: SyncAction {
  var payload: Int
  
  static func reduce(state: inout ToDoState, action: RemoveTodo) {
    state.todos.remove(at: action.payload)
    state.todosCompleted.remove(at: action.payload)

  }
}
