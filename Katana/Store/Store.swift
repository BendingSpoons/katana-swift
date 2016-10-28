//
//  Store.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public protocol AnyStore: class {
  func dispatch(_ action: AnyAction)
  func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe
  var anyState: State { get }
}

public class Store<StateType: State> {
  fileprivate var state: StateType
  fileprivate var listeners: [StoreListener]
  fileprivate let middlewares: [StoreMiddleware<StateType>]
  
  lazy private var dispatchFunction: StoreDispatch = {
    let m = self.middlewares.map { middleware in
      middleware(self.getState, self.dispatch)
    }
    return self.compose(m, with: self.performDispatch)
  }()
  
  lazy private var dispatchQueue: DispatchQueue = {
    // serial by default
    return DispatchQueue(label: "katana.store.queue")
  }()
  
  convenience public init() {
    self.init(middlewares: [])
  }
  
  public init(middlewares: [StoreMiddleware<StateType>]) {
    self.listeners = []
    self.state = StateType.init()
    self.middlewares = middlewares
  }

  public func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe {
    self.listeners.append(listener)
    let idx = listeners.count - 1
    
    return { [weak self] in
      _ = self?.listeners.remove(at: idx)
    }
  }
  
  public func dispatch(_ action: AnyAction) {
    self.dispatchQueue.async {
      self.dispatchFunction(action)
    }
  }
  
  public func getState() -> StateType {
    return self.state
  }
  
  private func performDispatch(_ action: AnyAction) {
    let newState = type(of: action).anyReduce(state: self.state, action: action)
    
    guard let typedNewState = newState as? StateType else {
      preconditionFailure("Action reducer returned a wrong state type")
    }
    
    print(typedNewState)
    self.state = typedNewState
    
    // listener are always invoked in the main queue
    DispatchQueue.main.async {
      self.listeners.forEach { $0() }
    }
  }
}

extension Store: AnyStore {
  public var anyState: State {
    return self.state
  }
}

fileprivate extension Store {
  fileprivate typealias PariallyAppliedMiddleware = (_ next: @escaping StoreDispatch) -> (_ action: AnyAction) -> Void

  fileprivate func compose(_ middlewares: [PariallyAppliedMiddleware],
                       with storeDispatch: @escaping StoreDispatch) -> StoreDispatch {

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
}
