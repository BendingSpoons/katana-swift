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

#warning("add also promise of the dispatched item")
public protocol DispatchObserverDispatchable: Dispatchable {
  init?(dispatchedItem: Dispatchable, prevState: State, currentState: State)
}

public protocol OnStartObserverDispatchable: Dispatchable {
  init?()
}

public struct ObserverInterceptor<S> where S: State {
  public enum ObserverType {
    public typealias StateChangeObserver = (_ prev: S, _ current: S) -> Bool
    public typealias AnyStateChangeObserver = (_ prev: State, _ current: State) -> Bool
    
    case whenStateChange(_ observer: StateChangeObserver, _ dispatchable: [StateObserverDispatchable.Type])
    case whenAnyStateChange(_ observer: AnyStateChangeObserver, _ dispatchable: [StateObserverDispatchable.Type])
    case onNotification(_ notification: Notification.Name, _ dispatchable: [NotificationObserverDispatchable.Type])
    case whenDispatched(_ dispatchable: Dispatchable.Type, _ dispatchable: [DispatchObserverDispatchable.Type])
    case onStart(_ dispatchable: [OnStartObserverDispatchable.Type])
  }
  
  private init() {}
  
  public static func observe(_ items: [ObserverType]) -> StoreInterceptor {
    return { getState, dispatch in
      
      let logic = ObserverLogic(dispatch: dispatch, items: items)
      logic.listenNotifications()
      logic.handleOnStart()
      
      return { next in
        return { dispatchable in
          
          let anyPrevState = getState()
          try next(dispatchable)
          let anyCurrState = getState()
          
          DispatchQueue.global(qos: .userInitiated).async {
            logic.handleDispatchable(dispatchable, anyPrevState: anyPrevState, anyCurrentState: anyCurrState)
          }
        }
      }
    }
  }
}

private struct ObserverLogic<S> where S: State {
  let dispatch: PromisableStoreDispatch
  let items: [ObserverInterceptor<S>.ObserverType]
  let dispatchableDictionary: [String: [DispatchObserverDispatchable.Type]]
  
  init(dispatch: @escaping PromisableStoreDispatch, items: [ObserverInterceptor<S>.ObserverType]) {
    self.dispatch = dispatch
    self.items = items
    
    var dictionary = [String: [DispatchObserverDispatchable.Type]]()
    
    for item in items {
      guard case let .whenDispatched(origin, itemsToDispatch) = item else {
        continue
      }
      
      let dispatchableStringName = ObserverLogic.stringName(for: origin)
      
      var items = dictionary[dispatchableStringName] ?? []
      items.append(contentsOf: itemsToDispatch)
      dictionary[dispatchableStringName] = items
    }
    
    self.dispatchableDictionary = dictionary
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
        
        self.dispatch(dispatchable)
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
    for item in self.items {
      switch item {
      case .onNotification, .onStart:
        continue // handled in a different way
        
      case let .whenAnyStateChange(changeClosure, dispatchableItems):
        self.handleStateChange(anyPrevState, anyCurrentState, changeClosure, dispatchableItems)
        
      case let .whenStateChange(changeClosure, dispatchableItems):
        self.handleStateChange(anyPrevState, anyCurrentState, changeClosure, dispatchableItems)
        
      case .whenDispatched:
        self.handleWhenDispatched(anyPrevState, anyCurrentState, dispatchable)
      }
    }
  }
  
  fileprivate func handleStateChange(
    _ anyPrevState: State,
    _ anyCurrentState: State,
    _ changeClosure: ObserverInterceptor<S>.ObserverType.StateChangeObserver,
    _ itemsToDispatch: [StateObserverDispatchable.Type]) {
    
    guard
      let prevState = anyPrevState as? S,
      let currentState = anyCurrentState as? S,
      changeClosure(prevState, currentState)
      
    else {
      return
    }
    
    for item in itemsToDispatch {
      guard let dispatchable = item.init(prevState: prevState, currentState: currentState) else {
        continue
      }
      
      _ = self.dispatch(dispatchable)
    }
  }
  
  fileprivate func handleWhenDispatched(
    _ anyPrevState: State,
    _ anyCurrentState: State,
    _ dispatched: Dispatchable) {
   
    guard let itemsToDispatch = self.dispatchableDictionary[ObserverLogic.stringName(for: dispatched)] else {
      return
    }
    
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
