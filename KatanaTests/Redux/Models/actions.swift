//
//  File.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import Katana

struct AddTodoAction: Action, Equatable {
  let actionName = "AddTodo"
  let title: String
  
  static func ==(lhs: AddTodoAction, rhs: AddTodoAction) -> Bool {
    return lhs.title == rhs.title
  }
}

struct RemoveTodoAction: Action {
  let actionName = "RemoveTodo"
  let id: String
}


struct ExternalAction: Action {
  let actionName = "External"
}
