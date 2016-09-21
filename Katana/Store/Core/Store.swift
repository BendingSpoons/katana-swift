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
  func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe
  var anyState: Any { get }
}

public class Store<RootReducer: Reducer> {
  public private(set) var state: RootReducer.StateType
  private var listeners: [StoreListener]
  private let middlewares: [StoreMiddleware<RootReducer.StateType>]
  
  lazy private var dispatchFunction: StoreDispatch = {
    let m = self.middlewares.map { middleware in
      middleware(self.getState, self.dispatch)
    }
    return compose(m, storeDispatch: self.performDispatch)
  }()
  
  lazy private var dispatchQueue: DispatchQueue = {
    // serial by default
    return DispatchQueue(label: "katana.store.queue")
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

  public func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe {
    self.listeners.append(listener)
    let idx = listeners.count - 1
    
    return { [weak self] in
      _ = self?.listeners.remove(at: idx)
    }
  }
  
  public func dispatch(_ action: Action) {
    self.dispatchQueue.async {
      self.dispatchFunction(action)
    }
  }
  
  public func getState() -> RootReducer.StateType {
    return self.state
  }
  
  private func performDispatch(_ action: Action) {
    self.state = RootReducer.reduce(action: action, state: self.state)
    
    // listener are always invoked in the main queue
    DispatchQueue.main.async {
      self.listeners.forEach { $0() }
    }
  }
}

extension Store: AnyStore {
  public var anyState: Any {
    return self.state
  }
}

private func compose(_ middlewares: [(_ next: @escaping StoreDispatch) -> (_ action: Action) -> Void],
                     storeDispatch: @escaping StoreDispatch) -> StoreDispatch {
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
