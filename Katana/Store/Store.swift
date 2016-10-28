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
//  private let middlewares: [StoreMiddleware<RootReducer.StateType>]
  
//  lazy private var dispatchFunction: StoreDispatch = {
//    let m = self.middlewares.map { middleware in
//      middleware(self.getState, self.dispatch)
//    }
//    return compose(m, storeDispatch: self.performDispatch)
//    return self.performDispatch
//  }()
  
  lazy private var dispatchQueue: DispatchQueue = {
    // serial by default
    return DispatchQueue(label: "katana.store.queue")
  }()
  
  public init() {
    self.listeners = []
    self.state = StateType.init()
//    self.middlewares = []
  }
  
//  public init(middlewares: [StoreMiddleware<RootReducer.StateType>]) {
//    self.listeners = []
//    self.state = RootReducer.StateType()
//    self.middlewares = middlewares
//  }

  public func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe {
    self.listeners.append(listener)
    let idx = listeners.count - 1
    
    return { [weak self] in
      _ = self?.listeners.remove(at: idx)
    }
  }
  
  public func dispatch(_ action: AnyAction) {
    self.dispatchQueue.async {
//      self.dispatchFunction(action)
      self.performDispatch(action)
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

//private func compose(_ middlewares: [(_ next: @escaping StoreDispatch) -> (_ action: Action) -> Void],
//                     storeDispatch: @escaping StoreDispatch) -> StoreDispatch {
//  guard middlewares.count > 0 else {
//    return storeDispatch
//  }
//  
//  guard middlewares.count > 1 else {
//    return middlewares.first!(storeDispatch)
//  }
//  
//  var m = middlewares
//  let last = m.removeLast()
//  
//  return m.reduce(last(storeDispatch), { chain, middleware in
//    return middleware(chain)
//  })
//}
