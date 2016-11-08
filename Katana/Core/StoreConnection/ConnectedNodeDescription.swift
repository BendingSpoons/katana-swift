//
//  ConnectedNodeDescription.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/// Type Erasure for `ConnectedNodeDescription`
public protocol AnyConnectedNodeDescription {
  /**
   Connects the storage state to the description.
   
   - seeAlso: `ConnectedNodeDescription`, `connect(props:to:)` method
  */
  static func anyConnect(parentProps: Any, storeState: Any) -> Any
}

/**
 In applications developed with Katana, the application information is stored in a central Store.
 There are cases where you want to take pieces of information from the central store and use them in your UI.
 `ConnectedNodeDescription` is the protocol that is used to implement this behaviour.
 
 By implementing this protocol in a description you get two behaviours: store information merging and automatic UI update.
 
 ### Merge description's props and Store's state
 Every time there is an UI update (e.g., because either props or state are changed), Katana allows you to
 inject in the props information that are taken from the central Store. You can use the `connect`
 method to implement this behaviour.
 
 ### Automatic UI update
 Every time the Store's state changes, you may want to update the UI. When you adopt the `ConnectedNodeDescription`
 protocol, Katana will trigger an UI update to all the nodes that are related to the description.
 The system will search for all the nodes that have a description that implements this protocol. It will then
 calculate the new props, by invoking `connect`. If the properties are changed, then the UI update is triggered.
 In this way we are able to effectively trigger UI changes only where and when needed.
 
 - seeAlso: `Store`
*/
public protocol ConnectedNodeDescription: AnyConnectedNodeDescription, NodeDescription {
  
  /// The State used in the application
  associatedtype StoreState: State
  
  /**
   This method is used to update the properties with pieces of information taken from the 
   central Store state.
   
   The idea of this method is that it takes the properties defined by the parent in the
   `childrenDescriptions` method and the store state.
   The implementation should update the props with all the information that are needed to properly
   render the UI.
   
   - parameter props:        the props defined by the parent
   - parameter storeState:   the state of the Store
  */
  static func connect(props: inout PropsType, to storeState: StoreState)
}

public extension ConnectedNodeDescription {
  /**
   Default implementation of `anyConnect`. It invokes `connect(props:to:)` by casting the parameters
   to the proper types.
   
   - seeAlso: `AnyConnectedNodeDescription`
  */
  static func anyConnect(parentProps: Any, storeState: Any) -> Any {
    
    guard let parentProps = parentProps as? PropsType, let s = storeState as? StoreState else {
      fatalError("invalid signature of the connect function of \(type(of: self))")
    }
    
    var parentPropsCopy = parentProps
    self.connect(props: &parentPropsCopy, to: s)
    return parentPropsCopy
  }
}
