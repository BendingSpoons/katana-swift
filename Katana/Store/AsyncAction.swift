//
//  AsyncAction.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// This enum represents the state of an `AsyncAction`
public enum AsyncActionState: Equatable {
  /// The action has just been created
  case loading

  /// The action's related operation has been completed
  case completed

  /// The action's related operation has failed
  case failed
  
  /// The action's related operation is in progress
  case progress(percentage: Double)
  
  /// The progress percentage associated with the state. Only available if the value of the enum is `.progress`
  public var progressPercentage: Double? {
    switch self {
    case let .progress(percentage: progress):
      return progress
    
    case .completed, .failed, .loading:
      return nil
    }
  }
  
  /// Implementation of the `Equatable` protocol
  public static func == (lhs: AsyncActionState, rhs: AsyncActionState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
      
    case (.completed, .completed):
      return true
      
    case (.failed, .failed):
      return true
      
    case let (.progress(lAmount), .progress(rAmount)):
      return lAmount == rAmount
      
    default:
      return false
    }
  }
}

/// Type Erasure for `AsyncAction`
public protocol AnyAsyncAction {

  /// The state of the action
  var state: AsyncActionState { get set }
}

/**
 Protocol that represents an `async` action.
 
 An `AsyncAction` is just an abstraction over `Action` that provides a way to structure
 your action.
 
 You typically use an `Async` action when you have to deal with operations that are asynchronous.
 In the most common scenario, you dispatch the initial action, execute an operation in the side effect 
 and then dispatch a completed/failed action based on the result of the operation. If the action has a concept
 of progress, you can also dispatch progress actions.
 
 This protocol has as the main goal to standardize the way async actions are managed.
 
 It is important to note that this is just a a convenience approach to something you can do anyway.
 You can for instance create three actions: `performOperation`, `OperationCompleted` and `OperationFailed` and achieve
 the same result. `AsyncAction` just provide a way to abstract and simplify the process
 
 #### Tip & Tricks
 Since the `Action` protocol is very generic when it comes to the state type that should be updated, a pattern
 we want to promote is to put in your application a protocol like the following:
 
 ```
 protocol AppSyncAction: AsyncAction {
  func updatedStateForLoading(currentState: inout AppState)
  // same for completed, failed and progress
 }
 
 extension AppSyncAction {
  func updatedStateForLoading(currentState: State) -> State {
    guard var state = state as? AppState else {
      fatalError("Something went wrong")
    }
 
    self.updatedStateForLoading(currentState: &state)
    return state
  }
 
  // same for completed, failed and progress
 }
 ```
 
 In this way you can save a lot of code since you can use your actions in the following way
 
 ```
 struct A: AppAsyncAction {
  func updatedStateForLoading(currentState: inout AppState) {
    state.props = action.payload
  }
 
  // same for completed, failed and progress
 }
 ```
*/
public protocol AsyncAction: Action, AnyAsyncAction {
  /**
   UpdateState function that will be used when the state of the action is `loading`
   
   - parameter state:   the current state of the application
   - returns: the new state
  */
  func updatedStateForLoading(currentState: State) -> State

  /**
   UpdateState function that will be used when the state of the action is `completed`
   
   - parameter state:   the current state of the application
   - returns: the new state
  */
  func updatedStateForCompleted(currentState: State) -> State

  /**
   UpdateState function that will be used when the state of the action is `failed`
   
   - parameter state:   the current state of the application
   - returns: the new state
  */
  func updatedStateForFailed(currentState: State) -> State

  /**
   UpdateState function that will be used when the state of the action is `progress`
   
   - parameter state:   the current state of the application
   - returns: the new state
  */
  func updatedStateForProgress(currentState: State) -> State

  /**
   Creates a new action in the `completed` state
   
   - parameter configuration: a block that updates the loading action
                              with the information of the completion
   - returns: a new instance of the action, where the state is `completed`.
              This new action will have the loading payload inerithed from the initial
              loading action and the provided additional information
  */
  func completedAction(_ configuration: (inout Self) -> ()) -> Self

  /**
   Creates a new action in the `failed` state
   
   - parameter configuration: a block that updates the loading action
                              with the information of the failure
   - returns: a new instance of the action, where the state is `failed`.
              This new action will have the loading payload inerithed from the initial
              loading action and the provided additional information
  */
  func failedAction(_ configuration: (inout Self) -> ()) -> Self
  
  /**
   Creates a new action in the `progress` state
   
   - parameter progress: the progress amount to set

   - returns: a new instance of the action, where the state is `progress`.
              This new action will have the loading payload inerithed from the initial
              loading action and the defined progress value
  */
  func progressAction(percentage: Double) -> Self
}

public extension AsyncAction {
  /**
   Creates a new state starting from the current state and the dispatched action.
   `AsyncAction` implements a default behaviour that invokes 
   `updatedStateForLoading(currentState:)`, `updatedStateForCompleted(currentState:)`,
   `updatedStateForFailed(currentState:)` or `updateStateForProgress(currentState:)` based on the action's state
   
   - parameter state:  the current state
   - returns: the new state
  */
  public func updatedState(currentState: State) -> State {
    switch self.state {
    case .loading:
      return self.updatedStateForLoading(currentState: currentState)

    case .completed:
      return self.updatedStateForCompleted(currentState: currentState)

    case .failed:
      return self.updatedStateForFailed(currentState: currentState)
      
    case .progress:
      return self.updatedStateForProgress(currentState: currentState)
    }
  }

  /**
   Creates a new action in the `completed` state
   
   - parameter configuration: a block that updates the loading action
   with the information of the completion
  
   - returns: a new instance of the action, where the state is `completed`.
   This new action will have the loading payload inerithed from the initial
   loading action and the provided additional information
  */
  public func completedAction(_ configuration: (inout Self) -> ()) -> Self {
    var copy = self
    copy.state = .completed
    configuration(&copy)
    return copy
  }
  
  /**
   Creates a new action in the `failed` state
   
   - parameter configuration: a block that updates the loading action
   with the information of the failure
   
   - returns: a new instance of the action, where the state is `failed`.
   This new action will have the loading payload inerithed from the initial
   loading action and the provided additional information
   */
  public func failedAction(_ configuration: (inout Self) -> ()) -> Self {
    var copy = self
    copy.state = .failed
    configuration(&copy)
    return copy
  }
  
  /**
   Creates a new action in the `progress` state
   
   - parameter progress: the progress amount to set
   
   - returns: a new instance of the action, where the state is `progress`.
   This new action will have the loading payload inerithed from the initial
   loading action and the defined progress value
  */
  public func progressAction(percentage: Double) -> Self {
    var copy = self
    copy.state = .progress(percentage: percentage)
    return copy
  }
}
