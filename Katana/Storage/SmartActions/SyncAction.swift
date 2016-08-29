//
//  SyncAction.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnySyncAction : Action {
  static func anySyncReduce( state: State, action: AnySyncAction) -> State
}

public protocol SyncAction : Action, AnySyncAction {
  associatedtype PayloadType
  associatedtype StateType
  
  var payload : PayloadType {get}
  
  static func syncReduce( state: inout StateType, action: Self)
}

public extension SyncAction {
  
  static var name : String {
    return "\(type(of: self))"
  }
  
  static func anySyncReduce( state: State, action: AnySyncAction) -> State {
    var state = state as! StateType
    let action = action as! Self
    
    syncReduce(state: &state, action: action)
    
    return state as! State
    
  }

}
