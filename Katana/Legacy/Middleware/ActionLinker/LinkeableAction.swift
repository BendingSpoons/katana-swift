//
//  LinkeableAction.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 Protocol to identify a linked action that must be dispatched after another action, 
 called source, is dispatched by the Store.
 */
@available(*, deprecated, message: "Use DispatchObserverDispatchable instead")
public protocol LinkeableAction: Action {
  /**
   Failable initializer for the LinkedAction.
   The parameters are used to choose if the action must effectively be created 
   (and so executed) or not
   
   A typical implementation could be
   ```
   if <condition on new state or on old state>{
    self = Action()
    return
   }
   
   return nil
   ```
   
   In general, you should not save in the action the oldStore nor the newStore.
   
   in the case of an AsyncAction, you can use the sourceAction.state as a switch if you 
   want to run the linkedAction when the source completes or fails.
   
   In this case the implementation could be
   ```
   if sourceAction.state == .completed && <condition on new state or on old state>{
    self = Action()
    return
   }
   
   return nil
   ```
   
   
   - parameter oldState: the state of the application before the source action is applied
   - parameter newState: the state of the application after the source action is applied
   - parameter sourceAction: the action on which the LinkeableAction depends upon
 */
  init?(oldState: State, newState: State, sourceAction: Action)
}
