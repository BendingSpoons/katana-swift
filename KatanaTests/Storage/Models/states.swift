//
//  stores.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import Katana

struct Todo: Equatable {
  let title: String
  let id: String
  
  static func ==(lhs: Todo, rhs: Todo) -> Bool {
    return lhs.title == rhs.title && lhs.id == rhs.id
  }
}

struct User: Equatable {
  let username: String
  
  static func ==(lhs: User, rhs: User) -> Bool {
    return lhs.username == rhs.username
  }
}

struct TodoState: State, Equatable {
  let todos: [Todo]
  
  static func ==(lhs: TodoState, rhs: TodoState) -> Bool {
    return lhs.todos == rhs.todos
  }
}

extension TodoState {
  init() {
    self.todos = []
  }
}

struct UserState: State, Equatable {
  let users: [User]

  static func ==(lhs: UserState, rhs: UserState) -> Bool {
    return lhs.users == rhs.users
  }
}

extension UserState {
  init() {
    self.users = []
  }
}

struct AppState: State, Equatable {
  let todo: TodoState
  let user: UserState
  
  static func ==(lhs: AppState, rhs: AppState) -> Bool {
    return lhs.todo == rhs.todo && lhs.user == rhs.user
  }
}

extension AppState {
  init() {
    self.todo = TodoState()
    self.user = UserState()
  }
}
