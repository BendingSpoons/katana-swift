//
//  Store.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

private func compose(_ middlewares: [(_ next: StoreDispatch) -> (_ action: Action) -> Void], storeDispatch: StoreDispatch) -> StoreDispatch {
  guard middlewares.count > 0 else {
    return storeDispatch
  }
  
  guard middlewares.count > 1 else {
    return middlewares.first!(storeDispatch)
  }
  
  var m = middlewares
  let last = m.removeLast()
  
  return m.reduce(last(storeDispatch), { chain, middleware in
    return middleware(chain)
  })
}

public class Store<RootReducer: Reducer> {
  private var state: RootReducer.StateType
  private var listeners: [StoreListener]
  private let middlewares: [StoreMiddleware<RootReducer>]
  
  lazy private var dispatchFunction: StoreDispatch = {
    let m = self.middlewares.map { $0(self) }
    return compose(m, storeDispatch: self.performDispatch)
  }()
  
  public init() {
    self.listeners = []
    self.state = RootReducer.StateType()
    self.middlewares = []
  }
  
  public init(middlewares: [StoreMiddleware<RootReducer>]) {
    self.listeners = []
    self.state = RootReducer.StateType()
    self.middlewares = middlewares
  }
  
  public func getState() -> RootReducer.StateType {
    return state
  }

  public func addListener(_ listener: StoreListener) -> StoreUnsubscribe {
    listeners.append(listener)
    let idx = listeners.count - 1
    
    return { [weak self] in
      _ = self?.listeners.remove(at: idx)
    }
  }
  
  public func dispatch(_ action: Action) {
    self.dispatchFunction(action)
  }
  
  private func performDispatch(_ action: Action) {
    // we dispatch everything in the main thread to avoid any possible issue
    // with multiple actions.
    // we can remove this limitation by adding an (atomic) FIFO queue where actions are added
    // while the current action has been completed
    
    guard Thread.isMainThread else {
      fatalError("actions must be dispatched in the main thread")
    }
    
    self.state = RootReducer.reduce(action: action, state: self.state)

    self.listeners.forEach { $0() }
  }
}

extension Store: AnyStore {
  public func getAnyState() -> Any {
    return self.getState()
  }
}

