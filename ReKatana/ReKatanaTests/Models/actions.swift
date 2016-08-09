//
//  File.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import ReKatana

struct AddTodoAction: Action, Equatable {
  let title: String
  
  static func ==(lhs: AddTodoAction, rhs: AddTodoAction) -> Bool {
    return lhs.title == rhs.title
  }
}

struct RemoveTodoAction: Action {
    let id: String
}


struct ExternalAction: Action {}
struct InitAction: Action {}
