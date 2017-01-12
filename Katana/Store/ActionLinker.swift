//
//  ActionLinker.swift
//  Katana
//
//  Created by Riccardo Cipolleschi on 11/01/2017.
//  Copyright © 2017 Bending Spoons. All rights reserved.
//

import Foundation

/**
 The engine that dispatches all the actions that depends on a triggered source action.
 This is invoked every time an action is dispatched. 
 The ActionLinker is responsible to check if there are actions that must be issued after a source actionis dispatched.
 For each of this actions, it checks if the conditions are met: if yes, they are dispatched.
 */
public struct ActionLinker {

  /**
   Dictionary used to store the links.
   We use a dictionary to make the access efficient. 
   The key is a String because Action does not implement Hashable.
   All the conversion between Action.Type and String is handled internally, 
   to leverage the type checking system.
   */
  let links: [String : [LinkeableAction.Type]]
  
  /**
   Initializer.
   The first element of LinkedActions is an Action.Type and not a String to enforce type safety and type checking. 
   The string conversion is entirely handled by the ActionLinker.
   
   - parameter links: the array of ActionLinks to register.
   */
  public init(links: [ActionLinks]) {
    var tmpLinks: [String: [LinkeableAction.Type]] = [:]
    
    /// Create the dictionary for a fast and efficient access to the actions.
    for tuple in links {
      let actionType = ActionLinker.stringName(for: tuple.source)
      tmpLinks[actionType] = tmpLinks[actionType] ?? []
      tmpLinks[actionType] = tmpLinks[actionType]! + tuple.links
    }
    
    ///Set the state variables
    self.links = tmpLinks
  }
  
  /**
   Core function of the linker.
   Extract the list of actions linked to a source that has been dispatched.
   If any, it executes them in order. Right now the order is relevant and it is the same used in the initialization.
   
   - parameter dispatch: the dispatch function of the Store.
   - parameter action: the source action that could trigger the action chain
   - parameter oldState: state of the application before the source action is applied
   - parameter newState: state of the application after the source action is applied
   */
  public func dispatchActions(for newState: State, oldState: State, sourceAction: AnyAction, dispatch: (Action) -> Void) {
    let linkedActions = self.links[ActionLinker.stringName(for: sourceAction)]
    
    guard let actions = linkedActions else {
      return
    }
    
    for action in actions {
      if let source = sourceAction as? Action,
        let action = action.init(oldState: oldState, newState: newState, sourceAction: source) {
          dispatch(action)
      }
    }
    
  }

  /**
   This takes an AnyAction and returns the name of the action by considering its namespace.
   
   - parameter action: the action for which you need the name.
   - return the namespaced name of the Action
   */
  public static func stringName(for action: AnyAction) -> String {
    return String(reflecting:(type(of: action)))
  }
  
  /**
   This takes an Action.Type and returns the name of the action by considering its namespace.
   
   - parameter action: the action type for which you need the name.
   - return the namespaced name of the Action.Type
   */
  public static func stringName(for actionType: Action.Type) -> String {
    return String(reflecting:actionType)
  }
}
