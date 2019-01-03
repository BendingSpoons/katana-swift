//
//  ObserverInterceptor.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 Protocol implemented by a dispatchable that wants to be dispatched in response to a notification
*/
public protocol NotificationObserverDispatchable: Dispatchable {
  /**
   Creates the dispatchable item. If for any reason, the init decides
   that the dispatchable should not be sent to the Store, the init can fail
   (that is, returns nil)
   
   - parameter notification: the notification that triggered the init
   - returns: either the dispatchable item or nil
  */
  init?(notification: Notification)
}

/**
 Protocol implemented by a dispatchable that wants to be dispatched in response to a change of the state 
 */
public protocol StateObserverDispatchable: Dispatchable {
  /**
   Creates the dispatchable item. If for any reason, the init decides
   that the dispatchable should not be sent to the Store, the init can fail
   (that is, returns nil)
   
   - parameter prevState: the last state before current changes
   - parameter currentState: the current state
   - returns: either the dispatchable item or nil
   */
  init?(prevState: State, currentState: State)
}

/**
Protocol implemented by a dispatchable that wants to be dispatched in response to the dispatch of another dispatchable
*/
public protocol DispatchObserverDispatchable: Dispatchable {
  /**
   Creates the dispatchable item. If for any reason, the init decides
   that the dispatchable should not be sent to the Store, the init can fail
   (that is, returns nil)
   
   - parameter dispatchedItem: the item that triggered the init
   - parameter prevState: the last state before current changes
   - parameter currentState: the current state
   - returns: either the dispatchable item or nil
   */
  init?(dispatchedItem: Dispatchable, prevState: State, currentState: State)
}

/**
 Protocol implemented by a dispatchable that wants to be dispatched when the store starts
*/
public protocol OnStartObserverDispatchable: Dispatchable {
  /**
   Creates the dispatchable item. If for any reason, the init decides
   that the dispatchable should not be sent to the Store, the init can fail
   (that is, returns nil)

   - returns: either the dispatchable item or nil
   */
  init?()
}

/**
 Interceptor that can be use to observe behaviours and dispatch items as a response.
 
 You can add as many `OnserverInterceptor` as you want to your application.
*/
public struct ObserverInterceptor {
  
  /// Creates the interceptor
  private init() {}
  
  /**
   Creates a new `ObserverInterceptor` that observes the passed events
   
   - parameter items: the list of events to observe
   - returns: the interceptor that observes the given items
  */
  public static func observe(_ items: [ObserverType]) -> StoreInterceptor {
    return { context in
      
      let logic = ObserverLogic(dispatch: context.dispatch, items: items)
      logic.listenToNotifications()
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

/// Internal implementation detail that implements the logic needed to observe the events
private struct ObserverLogic {
  
  /// The dispatch function of the store
  let dispatch: PromisableStoreDispatch
  
  /// The items to observe
  let items: [ObserverInterceptor.ObserverType]
  
  /**
   Creates a new logic.
   
   - parameter dispatch: the dispatch function of the store
   - parameter items: the items to observe
   - returns: a structure that holds the logic to handle the given items
  */
  init(dispatch: @escaping PromisableStoreDispatch, items: [ObserverInterceptor.ObserverType]) {
    self.dispatch = dispatch
    self.items = items
  }
  
  /**
   Listens the notifications contained in the passed items.
   
   This should be invoked as early as possible
  */
  fileprivate func listenToNotifications() {
    for item in self.items {
      
      guard case let .onNotification(notificationName, itemsToDispatch) = item else {
        continue
      }
      
      self.handleNotification(with: notificationName, itemsToDispatch)
    }
  }
  
  /**
   Handles the items that should be dispatched when the store starts
   
   This should be invoked when the store initialises the interceptor
  */
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

  /**
   Handles a specific notification by adding an observer (using NotificationCenter)
   that dispatches the given types
   
   - parameter name: the name of the notification to listen to
   - parameter typesToDispatch: the types of dispatchable to instantiate and dispatch when the
   notification is received
  */
  private func handleNotification(
    with name: NSNotification.Name,
    _ typesToDispatch: [NotificationObserverDispatchable.Type]) {

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
  
  /**
   Handles the fact that a dispatchable has been received and it changed the state from `anyPrevState` to
   `anyCurrentState`. The method takes care of dispatching proper items based on the observer configuration.
   
   - parameter dispatchable: the dispatchable that has been dispatched
   - parameter anyPrevState: the state before the execution of the dispatchable
   - parameter anyCurrentState: the state after the execution of the dispatchable
   */
  fileprivate func handleDispatchable(_ dispatchable: Dispatchable, anyPrevState: State, anyCurrentState: State) {
    
    let isSideEffect = dispatchable is AnySideEffect
    
    for item in self.items {
      switch item {
      case .onNotification, .onStart:
        continue // handled in a different way
        
      case let .onStateChange(changeClosure, dispatchableItems):
        self.handleOnStateChange(anyPrevState, anyCurrentState, isSideEffect, changeClosure, dispatchableItems)
        
      case .onDispatch(let observedType, let dispatchableItems) where type(of: dispatchable) == observedType:
        self.handleOnDispatched(dispatchableItems, anyPrevState, anyCurrentState, dispatchable)
        
      case .onDispatch:
        break // observedType mismatch
      }
    }
  }
  
  fileprivate func handleOnStateChange(
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
  
  /**
   Handles the items that must be dispatched in response to a dispatchable item.
   
   - parameter itemsToDispatch: the list of items that should be dispatched
   - parameter anyPrevState: the state before the execution of the dispatchable
   - parameter anyCurrentState: the state after the execution of the dispatchable
   - parameter dispatched: the dispatchable that has been dispatched
  */
  fileprivate func handleOnDispatched(
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
  
  /**
   String representation of the given dispatchable type
   - parameter dispatchable: the dispatchable type
  */
  fileprivate static func stringName(for dispatchable: Dispatchable.Type) -> String {
    return String(reflecting:(type(of: dispatchable)))
  }

  /**
   String representation of the given dispatchable
   - parameter dispatchable: the dispatchable
  */
  fileprivate static func stringName(for dispatchable: Dispatchable) -> String {
    return self.stringName(for: type(of: dispatchable))
  }
}

public extension ObserverInterceptor {
  /// Enum that contains the various events that can be observed
  public enum ObserverType {
    
    /// Type of closure that is used to check whether a state change should trigger the event
    public typealias StateChangeObserver = (_ prev: State, _ current: State) -> Bool
    
    /// Typed version of `StateChangeObserver`
    public typealias TypedStateChangeObserver<S: State> = (_ prev: S, _ current: S) -> Bool
    
    /**
     Observes a change in the state.
     - parameter observer: a function that should return true when the changes to the state should dispatch items
     - parameter dispatchable: a list of items to dispatch if the `observer` returns true
    */
    case onStateChange(_ observer: StateChangeObserver, _ dispatchable: [StateObserverDispatchable.Type])
    
    /**
     Observes a notification.
     - parameter notification: the name of the notification to observe
     - parameter dispatchable: a list of items to dispatch when the noficiation is sent
    */
    case onNotification(_ notification: Notification.Name, _ dispatchable: [NotificationObserverDispatchable.Type])
    
    /**
     Observes a dispatch
     - parameter dispatchable: the type of the dispatchable to observe
     - parameter dispatchable: a list of items to dispatch when `dispatchable` is dispatched
    */
    case onDispatch(_ dispatchable: Dispatchable.Type, _ dispatchable: [DispatchObserverDispatchable.Type])
    
    /**
     When the store starts
     - parameter dispatchable: a list of items to dispatch when the store starts
    */
    case onStart(_ dispatchable: [OnStartObserverDispatchable.Type])
    
    /**
     Helper method that transforms a `TypedStateChangeObserver` into a `StateChangeObserver`
     
     - parameter closure: the closure with type `TypedStateChangeObserver` to transform
     - returns: the closure with type `StateChangeObserver` that is logically equivalent to the given closure
    */
    public static func typedStateChange<S: State>(_ closure: @escaping TypedStateChangeObserver<S>) -> StateChangeObserver {
      return { prev, current in
        guard let typedPrev = prev as? S, let typedCurr = current as? S else {
          return false
        }
        
        return closure(typedPrev, typedCurr)
      }
    }
  }
}
