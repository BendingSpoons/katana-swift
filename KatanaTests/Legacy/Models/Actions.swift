//
//  Actions.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
@testable import Katana

public struct AddTodoAction: Action {
  public let title: String

  public func updatedState(currentState: State) -> State {
    guard var s = currentState as? AppState else { return currentState }

    let todo = Todo(title: self.title, id: UUID().uuidString)
    s.todo.todos = s.todo.todos + [todo]

    return s
  }
}

extension AddTodoAction: Equatable {
  public static func == (lhs: AddTodoAction, rhs: AddTodoAction) -> Bool {
    return lhs.title == rhs.title
  }
  
  public var debugDescription: String {
    return "\(String(reflecting: type(of: self))).\(self.title)"
  }
}

struct RemoveTodoAction: Action {
  let id: String

  func updatedState(currentState: State) -> State {
    guard var s = currentState as? AppState else { return currentState }

    let todos = s.todo.todos.filter { $0.id != self.id }
    s.todo.todos = todos

    return s
  }
}

struct SpyActionWithSideEffect: ActionWithSideEffect {
  typealias ActionWithSideEffectCallback = (
    _ currentState: State,
    _ previousState: State,
    _ dispatch: @escaping StoreDispatch,
    _ dependencies: SideEffectDependencyContainer) -> ()

  var sideEffectInvokedClosure: ActionWithSideEffectCallback?
  var updatedInvokedClosure: (() -> ())?

  public func updatedState(currentState: State) -> State {
    self.updatedInvokedClosure?()
    return currentState
  }
  
  public func sideEffect(
    currentState: State,
    previousState: State,
    dispatch: @escaping StoreDispatch,
    dependencies: SideEffectDependencyContainer) {
    
    self.sideEffectInvokedClosure?(currentState, previousState, dispatch, dependencies)
  }
}
