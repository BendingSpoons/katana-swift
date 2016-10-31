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
  func getAnyState() -> State
}

public class Store<StateType: State> {
  fileprivate var state: StateType
  fileprivate var listeners: [StoreListener]
  fileprivate let middlewares: [StoreMiddleware<StateType>]
  fileprivate let dependencyContainerType: SideEffectDependencyContainer.Type
  
  lazy fileprivate var dispatchFunction: StoreDispatch = {
    var m = self.middlewares.map { middleware in
      middleware(self.getState, self.dispatch)
    }
    
    // add the side effect function as the first in the chain
    m = [self.triggerSideEffect] + m
    
    return self.compose(m, with: self.performDispatch)
  }()
  
  lazy private var dispatchQueue: DispatchQueue = {
    // serial by default
    return DispatchQueue(label: "katana.store.queue")
  }()
  
  convenience public init() {
    self.init(middlewares: [], dependencyContainer: EmptySideEffectDependencyContainer.self)
  }
  
  public init(middlewares: [StoreMiddleware<StateType>], dependencyContainer: SideEffectDependencyContainer.Type) {
    self.listeners = []
    self.state = StateType.init()
    self.middlewares = middlewares
    self.dependencyContainerType = dependencyContainer
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
}

fileprivate extension Store {
  fileprivate typealias PartiallyAppliedMiddleware = (_ next: @escaping StoreDispatch) -> (_ action: AnyAction) -> Void

  fileprivate func compose(_ middlewares: [PartiallyAppliedMiddleware],
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
  
  fileprivate func performDispatch(_ action: AnyAction) {
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
  
  fileprivate func triggerSideEffect(next: @escaping StoreDispatch) -> ((AnyAction) -> Void) {
    return { action in
      defer {
        next(action)
      }
      
      guard let action = action as? AnySideEffectable else {
        return
      }
      
      let state = self.getState()
      let dispatch = self.dispatch
      let container = self.dependencyContainerType.init(state: state, dispatch: dispatch)
      
      type(of: action).anySideEffect(
        action: action,
        state: state,
        dispatch: dispatch,
        dependencies: container
      )
    }
  }
}

extension Store: AnyStore {
  public func getAnyState() -> State {
    return self.state
  }
}
