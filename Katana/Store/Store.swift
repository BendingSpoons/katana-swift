//
//  Store.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

public protocol AnyStore: class {
  var anyState: State { get }

  func dispatch(_ action: AnyAction)
  func addListener(_ listener: @escaping StoreListener) -> StoreUnsubscribe
}

public class Store<StateType: State> {
  public fileprivate(set) var state: StateType
  fileprivate var listeners: [StoreListener]
  fileprivate let middlewares: [StoreMiddleware<StateType>]
  fileprivate let dependencies: SideEffectDependencyContainer.Type
  
  lazy fileprivate var dispatchFunction: StoreDispatch = {
    var getState = { [unowned self] () -> StateType in
      return self.state
    }
    
    var m = self.middlewares.map { middleware in
      middleware(getState, self.dispatch)
    }
    
    // add the side effect function as the first in the chain
    m = [self.triggerSideEffect] + m
    
    return self.composeMiddlewares(m, with: self.performDispatch)
  }()
  
  lazy private var dispatchQueue: DispatchQueue = {
    // serial by default
    return DispatchQueue(label: "katana.store.queue")
  }()
  
  convenience public init() {
    self.init(middlewares: [], dependencies: EmptySideEffectDependencyContainer.self)
  }
  
  public init(middlewares: [StoreMiddleware<StateType>], dependencies: SideEffectDependencyContainer.Type) {
    self.listeners = []
    self.state = StateType.init()
    self.middlewares = middlewares
    self.dependencies = dependencies
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
}

fileprivate extension Store {
  fileprivate typealias PartiallyAppliedMiddleware = (_ next: @escaping StoreDispatch) -> (_ action: AnyAction) -> Void

  fileprivate func composeMiddlewares(_ middlewares: [PartiallyAppliedMiddleware],
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
    let newState = type(of: action).anyUpdatedState(currentState: self.state, action: action)
    
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
      
      guard let action = action as? AnyActionWithSideEffect else {
        return
      }
      
      let state = self.state
      let dispatch = self.dispatch
      let container = self.dependencies.init(state: state, dispatch: dispatch)
      
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
  public var anyState: State {
    return self.state
  }
}
