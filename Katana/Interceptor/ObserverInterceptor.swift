//
//  ObserverInterceptor.swift
//  Katana
//
//  Created by Mauro Bolis on 25/10/2018.
//

import Foundation

public protocol NotificationObserverDispatchable: Dispatchable {
  init?(notification: Notification)
}

public protocol StateObserverDispatchable: Dispatchable {
  init?(prevState: State, currentState: State)
}

public protocol DispatchObserverDispatchable: Dispatchable {
  init?(dispatchedItem: Dispatchable, prevState: State, currentState: State)
}

public protocol OnStartObserverDispatchable: Dispatchable {
  init?()
}

public struct ObserverInterceptor {
  public enum ObserverType {
    public typealias StateChangeObserver = (_ prev: State, _ current: State) -> Bool
    public typealias TypedStateChangeObserver<S: State> = (_ prev: S, _ current: S) -> Bool
    
    case whenStateChange(_ observer: StateChangeObserver, _ dispatchable: [StateObserverDispatchable.Type])
    case onNotification(_ notification: Notification.Name, _ dispatchable: [NotificationObserverDispatchable.Type])
    case whenDispatched(_ dispatchable: Dispatchable.Type, _ dispatchable: [DispatchObserverDispatchable.Type])
    case onStart(_ dispatchable: [OnStartObserverDispatchable.Type])
    
    public static func typedStateChange<S: State>(_ closure: @escaping TypedStateChangeObserver<S>) -> StateChangeObserver {
      return { prev, current in
        guard let typedPrev = prev as? S, let typedCurr = current as? S else {
          return false
        }
        
        return closure(typedPrev, typedCurr)
      }
    }
  }
  
  private init() {}
  
  public static func observe(_ items: [ObserverType]) -> StoreInterceptor {
    return { context in
      
      let logic = ObserverLogic(dispatch: context.dispatch, items: items)
      logic.listenNotifications()
      logic.handleOnStart()
      
      return { next in
        return { dispatchable in
          
          let anyPrevState = context.getAnyState()
          try next(dispatchable)
          let anyCurrState = context.getAnyState()
          
          DispatchQueue.global(qos: .userInitiated).async {
            logic.handleDispatchable(dispatchable, anyPrevState: anyPrevState, anyCurrentState: anyCurrState)
          }
        }
      }
    }
  }
}

private struct ObserverLogic {
  let dispatch: PromisableStoreDispatch
  let items: [ObserverInterceptor.ObserverType]
  
  init(dispatch: @escaping PromisableStoreDispatch, items: [ObserverInterceptor.ObserverType]) {
    self.dispatch = dispatch
    self.items = items
  }
  
  fileprivate func listenNotifications() {
    for item in self.items {
      
      guard case let .onNotification(notificationName, itemsToDispatch) = item else {
        continue
      }
      
      self.handleNotification(with: notificationName, itemsToDispatch)
    }
  }
  
  fileprivate func handleOnStart() {
    for item in self.items {
      
      guard case let .onStart(itemsToDispatch) = item else {
        continue
      }
      
      
      
      for item in itemsToDispatch {
        guard let dispatchable = item.init() else {
          continue
        }
        
        _ = self.dispatch(dispatchable)
      }
    }
  }
  
  private func handleNotification(with name: NSNotification.Name, _ typesToDispatch: [NotificationObserverDispatchable.Type]) {
    NotificationCenter.default.addObserver(
      forName: name,
      object: nil,
      queue: nil,
      using: { notification in

        for type in typesToDispatch {
          guard let dispatchable = type.init(notification: notification) else {
            continue
          }
          
          _ = self.dispatch(dispatchable)
        }
      }
    )
  }
  
  
  fileprivate func handleDispatchable(_ dispatchable: Dispatchable, anyPrevState: State, anyCurrentState: State) {
    
    let isSideEffect = dispatchable is AnySideEffect
    
    for item in self.items {
      switch item {
      case .onNotification, .onStart:
        continue // handled in a different way
        
      case let .whenStateChange(changeClosure, dispatchableItems):
        self.handleStateChange(anyPrevState, anyCurrentState, isSideEffect, changeClosure, dispatchableItems)
        
      case .whenDispatched(let observedType, let dispatchableItems) where type(of: dispatchable) == observedType:
        self.handleWhenDispatched(dispatchableItems, anyPrevState, anyCurrentState, dispatchable)
        
      case .whenDispatched:
        break // observedType mismatch
      }
    }
  }
  
  fileprivate func handleStateChange(
    _ anyPrevState: State,
    _ anyCurrentState: State,
    _ isSideEffect: Bool,
    _ changeClosure: ObserverInterceptor.ObserverType.StateChangeObserver,
    _ itemsToDispatch: [StateObserverDispatchable.Type]) {
    
    guard !isSideEffect && changeClosure(anyPrevState, anyCurrentState) else {
      return
    }
    
    for item in itemsToDispatch {
      guard let dispatchable = item.init(prevState: anyPrevState, currentState: anyCurrentState) else {
        continue
      }
      
      _ = self.dispatch(dispatchable)
    }
  }
  
  fileprivate func handleWhenDispatched(
    _ itemsToDispatch: [DispatchObserverDispatchable.Type],
    _ anyPrevState: State,
    _ anyCurrentState: State,
    _ dispatched: Dispatchable) {
    
    for item in itemsToDispatch {
      guard let dispatchable = item.init(dispatchedItem: dispatched, prevState: anyPrevState, currentState: anyCurrentState) else {
        continue
      }
      _ = self.dispatch(dispatchable)
    }
  }
  
  fileprivate static func stringName(for dispatchable: Dispatchable.Type) -> String {
    return String(reflecting:(type(of: dispatchable)))
  }
  
  fileprivate static func stringName(for dispatchable: Dispatchable) -> String {
    return self.stringName(for: type(of: dispatchable))
  }
}
