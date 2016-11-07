//
//  SyncAction.swift
//  Katana
//
//  Created by Mauro Bolis on 28/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/**
 Protocol that represents a `sync` action.
 
 A `SyncAction` is just an abstraction over `Action` that provides a way to structure
 your action. In particular the action payload should be assigned to a single `payload` value
 (which can be anything). We introduced this pattern to allow future automatic behaviours such as
 automatic serialization/deserialization of the actions
 (that can be used for debugging, time travel and so on)
 
 #### Tip & Tricks
 Since the `Action` protocol is very generic when it comes to the state type that should be updated, a pattern
 we want to promote is to put in your application a protocol like the following:
 
 ```
 protocol AppSyncAction: SyncAction {
  static func updateState(currentState: inout AppState, action: AddTodo)
 }
 
 extension AppSyncAction {
  static func updateState(currentState: State, action: AddTodo) -> State {
    guard var state = currentState as? AppState else {
      fatalError("Something went wrong")
    }
 
    self.updateState(currentState: &state, action: action)
    return state
  }
 }
 ```
 
 In this way you can save a lot of code since you can use your actions in the following way
 
 ```
 struct A: AppSyncAction {
  static func updateState(currentState: inout AppState, action: AddTodo) {
    currentState.props = action.payload
  }
 }
 ```
*/
public protocol SyncAction: Action {

  /// The payload type of the action
  associatedtype Payload
  
  /// The payload of the action
  var payload: Payload { get }
}
