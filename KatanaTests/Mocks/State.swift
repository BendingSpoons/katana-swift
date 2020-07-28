//
//  State.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
@testable import Katana

struct Todo: Equatable {
  let title: String
  let id: String
}

struct User: Equatable {
  let username: String
}

struct TodoState: State, Equatable {
  var todos: [Todo]
}

extension TodoState {
  init() {
    self.todos = []
  }
}

struct UserState: State, Equatable {
  var users: [User]
}

extension UserState {
  init() {
    self.users = []
  }
}

struct AppState: State, Equatable {
  var todo: TodoState
  var user: UserState
}

extension AppState {
  init() {
    self.todo = TodoState()
    self.user = UserState()
  }
}

protocol TestStateUpdater: StateUpdater where StateType == AppState {
  
}

protocol TestSideEffect: SideEffect where StateType == AppState, Dependencies == TestDependenciesContainer {
  
}

protocol ReturningTestSideEffect: ReturningSideEffect where ReturnValue == AppState {
  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> ReturnValue
}

extension ReturningTestSideEffect {
  func sideEffect(_ context: AnySideEffectContext) throws -> ReturnValue {
    guard let typedContext = context as? SideEffectContext<AppState, TestDependenciesContainer> else {
      fatalError()
    }

    return try self.sideEffect(typedContext)
  }
}
