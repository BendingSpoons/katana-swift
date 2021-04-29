//
//  Dispatchables.swift
//  KatanaTests
//
//  Created by Daniele Formichelli on 28/04/21.
//  Copyright © 2021 BendingSpoons. All rights reserved.
//

import Foundation
import Hydra
import Katana

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

struct AddTodo: TestStateUpdater {
  let todo: Todo

  func updateState(_ state: inout AppState) {
    state.todo.todos.append(self.todo)
  }
}

struct AddUser: TestStateUpdater {
  let user: User

  func updateState(_ state: inout AppState) {
    state.user.users.append(self.user)
  }
}

struct ClosureSideEffect: TestSideEffect {
  var delay: TimeInterval
  var invocationClosure: (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> Void

  init(
    delay: TimeInterval = 0,
    invocationClosure: @escaping (_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws -> Void = { _ in }
  ) {
    self.delay = delay
    self.invocationClosure = invocationClosure
  }

  func sideEffect(_ context: SideEffectContext<AppState, TestDependenciesContainer>) throws {
    if delay != 0 {
      try Hydra.await(context.dependencies.delay(of: self.delay))
    }

    try invocationClosure(context)
  }
}
