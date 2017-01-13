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
   Function that takes an array of action links and reduce them to a dictionary.
   This is useful to get efficiently all the links of a specific source action.
   
   - parameter from: the array to be reduced
   - returns: a dictionary with the name of the action and the list of linked actions
   - warning: it does not remove duplicated actions!
   */
  static func reduceLinks(from array: [ActionLinks]) -> [String: [LinkeableAction.Type]] {
    var tmpLinks: [String: [LinkeableAction.Type]] = [:]
    
    for tuple in array {
      let actionType = ActionLinker.stringName(for: tuple.source)
      tmpLinks[actionType] = tmpLinks[actionType] ?? []
      tmpLinks[actionType] = tmpLinks[actionType]! + tuple.links
    }
    
    return tmpLinks
  }
  
  /**
   Core function of the linker.
   Extract the list of actions linked to a source that has been dispatched.
   If any, it executes them in order. Right now the order is relevant and it is the same used in the initialization.
   

   - parameter newState: state of the application after the source action is applied
   - parameter oldState: state of the application before the source action is applied
   - parameter action: the source action that could trigger the action chain
   - parameter links: the array with all the linked actions
   - parameter dispatch: the dispatch function of the Store.
   */
  static func dispatchActions(for newState: State,
                              oldState: State,
                              sourceAction: AnyAction,
                              links: [String: [LinkeableAction.Type]],
                              dispatch: (Action) -> Void) {
    
    let linkedActions = links[ActionLinker.stringName(for: sourceAction)]
    
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
   - returns: the namespaced name of the Action
   */
  static func stringName(for action: AnyAction) -> String {
    return String(reflecting:(type(of: action)))
  }
  
  /**
   This takes an Action.Type and returns the name of the action by considering its namespace.
   
   - parameter action: the action type for which you need the name.
   - returns: the namespaced name of the Action.Type
   */
  static func stringName(for actionType: Action.Type) -> String {
    return String(reflecting:actionType)
  }
  
  /**
   This function returns a StoreMiddleware that chains the actions defined as linked
   
   - see `StoreMiddleware` for details.
   */
  public static func middleware(for linkedActions: [ActionLinks]) -> StoreMiddleware {
    
    let reducedLinks = ActionLinker.reduceLinks(from: linkedActions)
    
    return { getState, dispatch in
      return { next in
        return { action in
          
          let oldState = getState()
          next(action)
          let newState = getState()
          ActionLinker.dispatchActions(for: newState,
                                       oldState: oldState,
                                       sourceAction: action,
                                       links: reducedLinks,
                                       dispatch: dispatch)
        }
      }
    }
  }
}
