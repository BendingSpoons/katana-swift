//
//  Store.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

typealias StoreListener<RootReducer: Reducer> = (store: Store<RootReducer>) -> Void
typealias StoreUnsubscribe = () -> ()

typealias StoreMiddleware<RootReducer: Reducer> = (store: Store<RootReducer>) -> (next: StoreDispatch) -> (action: Action) -> Void
typealias StoreDispatch = (_: Action) -> Void


private func compose(_ middlewares: [(next: StoreDispatch) -> (action: Action) -> Void], storeDispatch: StoreDispatch) -> StoreDispatch {
  guard middlewares.count > 0 else {
    return storeDispatch
  }
  
  guard middlewares.count > 1 else {
    return middlewares.first!(next: storeDispatch)
  }
  
  var m = middlewares
  let last = m.removeLast()
  
  return m.reduce(last(next: storeDispatch), { chain, middleware in
    return middleware(next: chain)
  })
}

class Store<RootReducer: Reducer> {
  private var state: RootReducer.StateType
  private var listeners: [StoreListener<RootReducer>]
  private let middlewares: [StoreMiddleware<RootReducer>]
  
  lazy private var dispatchFunction: StoreDispatch = {
    let m = self.middlewares.map { $0(store: self) }
    return compose(m, storeDispatch: self.performDispatch)
  }()
  
  init(_: RootReducer.Type) {
    self.listeners = []
    self.state = RootReducer.reduce(action: InitAction(), state: nil)
    self.middlewares = []
  }
  
  init(_: RootReducer.Type, middlewares: [StoreMiddleware<RootReducer>]) {
    self.listeners = []
    self.state = RootReducer.reduce(action: InitAction(), state: nil)
    self.middlewares = middlewares
  }
  
  func getState() -> RootReducer.StateType {
    return state
  }
  
  func addListener(_ listener: StoreListener<RootReducer>) -> StoreUnsubscribe {
    listeners.append(listener)
    let idx = listeners.count - 1
    
    return { [weak self] in
      _ = self?.listeners.remove(at: idx)
    }
  }
  
  func dispatch(_ action: Action) {
    self.dispatchFunction(action)
  }
  
  private func performDispatch(_ action: Action) {
    // we dispatch everything in the main thread to avoid any possible issue
    // with multiple actions.
    // we can remove this limitation by adding an (atomic) FIFO queue where actions are added
    // while the current action has been completed
    assert(Thread.isMainThread, "It is currently possible to dispatch actions only in the main thread")
    self.state = RootReducer.reduce(action: action, state: self.state)
    
    self.listeners.forEach { $0(store: self) }
  }
}
