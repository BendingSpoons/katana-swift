//
//  Store.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public protocol AnyStore: class {
  func dispatch(_ action: Action)
  func addListener(_ listener: StoreListener) -> StoreUnsubscribe
  // the name is not getState because otherwise we cannot use inferred types anymore
  // since getState can also return any
  func getAnyState() -> Any
}

public class Store<RootReducer: Reducer> {
  public private(set) var state: RootReducer.StateType
  private var listeners: [StoreListener]
  private let middlewares: [StoreMiddleware<RootReducer.StateType>]
  
  lazy private var dispatchFunction: StoreDispatch = {
    let m = self.middlewares.map { middleware in
      middleware(self.state, self.dispatch)
    }
    return compose(m, storeDispatch: self.performDispatch)
  }()
  
  public init() {
    self.listeners = []
    self.state = RootReducer.StateType()
    self.middlewares = []
  }
  
  public init(middlewares: [StoreMiddleware<RootReducer.StateType>]) {
    self.listeners = []
    self.state = RootReducer.StateType()
    self.middlewares = middlewares
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
    // we dispatch everything in the main queue to avoid any possible issue
    // with multiple actions.
    // we can remove this limitation by adding an (atomic) FIFO queue where actions are added
    // while the current action has been completed
    
    dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
    
    self.state = RootReducer.reduce(action: action, state: self.state)

    self.listeners.forEach { $0() }
  }
}

extension Store: AnyStore {
  public func getAnyState() -> Any {
    return self.state
  }
}

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

