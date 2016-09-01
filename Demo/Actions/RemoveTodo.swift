//
//  DownloadPhotos.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct RemoveTodo : SyncSmartAction {
  var payload: Int
  
  static func reduce(state: inout AppState, action: RemoveTodo) {
    state.todos.remove(at: action.payload)
  }
  
}
