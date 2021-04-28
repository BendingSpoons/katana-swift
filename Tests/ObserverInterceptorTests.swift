//
//  ObserverInterceptorTests.swift
//  Katana
//
//  Copyright © 2021 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Hydra
import XCTest

@testable import Katana

class ObserverInterceptorTests: XCTestCase {
  // MARK: AppState StateChangeObserver

  func testObserveOnStateChange_whenUsingAppStateChangeObserver_dispatchesDispatchable() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStateChange(
        ObserverInterceptor.ObserverType.typedStateChange { prev, curr in
          return prev.todo.todos.count != curr.todo.todos.count
        },
        [StateChangeAddUser.self]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    self.waitFor { store.state.user.users.count == 1 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnStateChange_whenUsingAppStateChangeObserverAndMultipleDispatchables_dispatchesAllOfThem() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStateChange(
        ObserverInterceptor.ObserverType.typedStateChange { prev, curr in
          return prev.todo.todos.count != curr.todo.todos.count
        },
        [
          StateChangeAddUser.self,
          StateChangeAddUser.self,
          StateChangeAddUser.self,
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    store.dispatch(AddTodo(todo: todo))

    self.waitFor { store.state.user.users.count == 3 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnStateChange_whenUsingAppStateChangeObserverAndNillableInitDispatchables_discardsNilOnes() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStateChange(
        ObserverInterceptor.ObserverType.typedStateChange { prev, curr in
          return prev.todo.todos.count != curr.todo.todos.count
        },
        [
          NilStateChangeAddUser.self,
          StateChangeAddUser.self,
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    self.waitFor { store.state.user.users.count == 1 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnStateChange_whenUsingAppStateChangeObserver_doesNotInterceptSideEffects() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStateChange(
        ObserverInterceptor.ObserverType.typedStateChange { _, _ in
          XCTFail("StateChangeObserver must not be called for side effects")
          return false
        },
        []
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    self.waitForPromise(store.dispatch(ClosureSideEffect()))
  }

  // MARK: State StateChangeObserver

  func testObserveOnStateChange_whenUsingStateChangeObserver_dispatchesDispatchable() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStateChange(
        { prev, curr in
          guard let prevState = prev as? AppState, let currState = curr as? AppState else {
            return false
          }
          return prevState.todo.todos.count != currState.todo.todos.count
        },
        [StateChangeAddUser.self]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    self.waitFor { store.state.user.users.count == 1 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnStateChange_whenUsingStateChangeObserverAndMultipleDispatchables_dispatchesAllOfThem() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStateChange(
        { prev, curr in
          guard let prevState = prev as? AppState, let currState = curr as? AppState else {
            return false
          }
          return prevState.todo.todos.count != currState.todo.todos.count
        },
        [
          StateChangeAddUser.self,
          StateChangeAddUser.self,
          StateChangeAddUser.self,
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    self.waitFor { store.state.user.users.count == 3 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnStateChange_whenUsingStateChangeObserverAndNillableInitDispatchables_discardsNilOnes() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStateChange(
        { prev, curr in
          guard let prevState = prev as? AppState, let currState = curr as? AppState else {
            return false
          }
          return prevState.todo.todos.count != currState.todo.todos.count
        },
        [
          NilStateChangeAddUser.self,
          StateChangeAddUser.self,
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    self.waitFor { store.state.user.users.count == 1 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnStateChange_whenUsingStateChangeObserver_doesNotInterceptSideEffects() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStateChange(
        { _, _ in
          XCTFail("StateChangeObserver must not be called for side effects")
          return false
        },
        [
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    self.waitForPromise(store.dispatch(ClosureSideEffect()))
  }

  // MARK: Dispatchable

  func testObserveOnDispatch_dispatchesDispatchables() throws {
    let interceptor = ObserverInterceptor.observe([
      .onDispatch(
        AddTodo.self,
        [StateChangeAddUser.self]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    self.waitFor { store.state.user.users.count == 1 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnDispatch_whenMultipleDispatchables_dispatchesAllOfThem() throws {
    let interceptor = ObserverInterceptor.observe([
      .onDispatch(
        AddTodo.self,
        [
          StateChangeAddUser.self,
          StateChangeAddUser.self,
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    self.waitFor { store.state.user.users.count == 2 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnDispatch_whenNillableInitDispatchables_discardsNilOnes() throws {
    let interceptor = ObserverInterceptor.observe([
      .onDispatch(
        AddTodo.self,
        [
          NilStateChangeAddUser.self,
          StateChangeAddUser.self,
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    self.waitForPromise(store.dispatch(AddTodo(todo: todo)))

    self.waitFor { store.state.user.users.count == 1 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  func testObserveOnDispatch_whenMultipleObservers_observesAllOfThem() throws {
    let interceptor = ObserverInterceptor.observe([
      .onDispatch(
        AddTodo.self,
        [StateChangeAddUser.self]
      ),
      .onDispatch(
        AddTodo.self,
        [StateChangeAddUser.self]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    let todo = Todo(title: "title", id: "id")
    store.dispatch(AddTodo(todo: todo))

    self.waitFor { store.state.user.users.count == 2 }
    XCTAssertEqual(store.state.todo.todos, [todo])
  }

  // MARK: Notification

  func testObserveOnNotification_dispatchesDispatchables() throws {
    let notificationCenter = NotificationCenter()
    let interceptor = ObserverInterceptor.observe(
      [
        .onNotification(
          testNotification.self,
          [StateChangeAddUser.self]
        ),
      ],
      notificationCenter: notificationCenter
    )

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
    self.waitFor { store.isReady }

    notificationCenter.post(name: testNotification, object: nil)

    self.waitFor { store.state.user.users.count == 1 }
  }

  func testObserveOnNotification_whenMultipleDispatchables_dispatchesAllOfThem() throws {
    let notificationCenter = NotificationCenter()
    let interceptor = ObserverInterceptor.observe(
      [
        .onNotification(
          testNotification.self,
          [
            StateChangeAddUser.self,
            StateChangeAddUser.self,
          ]
        ),
      ],
      notificationCenter: notificationCenter
    )

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
    self.waitFor { store.isReady }

    notificationCenter.post(name: testNotification, object: nil)

    self.waitFor { store.state.user.users.count == 2 }
  }

  func testObserveOnNotification_whenNillableInitDispatchables_discardsNilOnes() throws {
    let notificationCenter = NotificationCenter()
    let interceptor = ObserverInterceptor.observe(
      [
        .onNotification(
          testNotification.self,
          [
            NilStateChangeAddUser.self,
            StateChangeAddUser.self,
          ]
        ),
      ],
      notificationCenter: notificationCenter
    )

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])
    self.waitFor { store.isReady }

    notificationCenter.post(name: testNotification, object: nil)

    self.waitFor { store.state.user.users.count == 1 }
  }

  // MARK: Startup

  func testObserveOnStart_dispatchesDispatchables() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStart(
        [StateChangeAddUser.self]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    self.waitFor { store.state.user.users.count == 1 }
  }

  func testObserveOnStart_whenMultipleDispatchables_dispatchesAllOfThem() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStart(
        [
          StateChangeAddUser.self,
          StateChangeAddUser.self,
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    self.waitFor { store.state.user.users.count == 2 }
  }

  func testObserveOnStart_whenNillableInitDispatchables_discardsNilOnes() throws {
    let interceptor = ObserverInterceptor.observe([
      .onStart(
        [
          NilStateChangeAddUser.self,
          StateChangeAddUser.self,
        ]
      ),
    ])

    let store = Store<AppState, TestDependenciesContainer>(interceptors: [interceptor])

    self.waitFor { store.state.user.users.count == 1 }
  }

  // MARK: Deallocation

  func testObserveOnNotification_whenStoreIsDeallocated_unregistersObserver() throws {
    let notificationCenter = TestableNotificationCenter()
    let interceptor = ObserverInterceptor.observe(
      [
        .onNotification(
          testNotification,
          [StateChangeAddUser.self]
        ),
      ],
      notificationCenter: notificationCenter
    )

    var store: Store<AppState, TestDependenciesContainer>? = .init(interceptors: [interceptor])
    self.waitFor { store?.isReady ?? false }

    notificationCenter.post(name: testNotification, object: nil)

    self.waitFor { store?.state.user.users.count == 1 }
    XCTAssertEqual(notificationCenter.observers.count, 1)

    store = nil
    XCTAssertEqual(notificationCenter.observers.count, 0)
  }
}

// MARK: Helpers

private let testNotification = Notification.Name("Test_Notification")

private struct AddTodoWithDelay: TestStateUpdater {
  let todo: Todo
  let waitingTime: TimeInterval

  func updateState(_ state: inout AppState) {
    // Note: this is just for testing, never do things like this in real apps
    Thread.sleep(forTimeInterval: self.waitingTime)
    state.todo.todos.append(self.todo)
  }
}

private struct StateChangeAddUser: TestStateUpdater,
  StateObserverDispatchable,
  DispatchObserverDispatchable,
  NotificationObserverDispatchable,
  OnStartObserverDispatchable {
  init?(prevState _: State, currentState _: State) {}

  init?(dispatchedItem _: Dispatchable, prevState _: State, currentState _: State) {}

  init?(notification _: Notification) {}

  init?() {}

  func updateState(_ state: inout AppState) {
    state.user.users.append(User(username: "the username"))
  }
}

private struct NilStateChangeAddUser: TestStateUpdater,
  StateObserverDispatchable,
  DispatchObserverDispatchable,
  NotificationObserverDispatchable,
  OnStartObserverDispatchable {
  init?(prevState _: State, currentState _: State) {
    return nil
  }

  init?(dispatchedItem _: Dispatchable, prevState _: State, currentState _: State) {
    return nil
  }

  init?(notification _: Notification) {
    return nil
  }

  init?() {
    return nil
  }

  func updateState(_ state: inout AppState) {
    state.user.users.append(User(username: "the username"))
  }
}

private class TestableNotificationCenter: NotificationCenter {
  var observers: [NSObjectProtocol] = []

  override func addObserver(
    forName name: NSNotification.Name?,
    object obj: Any?,
    queue: OperationQueue?,
    using block: @escaping (Notification) -> Void
  ) -> NSObjectProtocol {
    let observer = super.addObserver(forName: name, object: obj, queue: queue, using: block)
    self.observers.append(observer)
    return observer
  }

  override func removeObserver(_ observer: Any) {
    super.removeObserver(observer)
    self.observers.removeAll(where: { $0.isEqual(observer) })
  }
}
