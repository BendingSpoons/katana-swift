//
//  AppState.swift
//  Katana
//
//  Created by Luca Querella on 24/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana


struct AppState : State {
  var pin: [Int]?
  var instructionShown: Bool
}


typealias SetPinActionType = SyncAction<[Int]>
let SetPinAction = SyncActionCreator<[Int]>(withName: "SetPin")

typealias DismissInstructionsActionType = SyncAction<Bool>
let DismissInstructionsAction = SyncActionCreator<Bool>(withName: "DismissInstructions")


struct SetPingReducer : SyncReducer {
  static func reduceSync(action: SetPinActionType, state: AppState) -> AppState {
    var state = state
    state.pin = action.payload
    return state
  }
}

struct DismissInstructionsReducer : SyncReducer {
  static func reduceSync(action: DismissInstructionsActionType, state: AppState) -> AppState {
    var state = state
    state.instructionShown = true
    return state
  }
}


struct AppReducer : ReducerCombiner   {
  
  static var initialState = AppState(pin: nil, instructionShown: false)
  static var reducers : [String:AnyReducer.Type] = [
    SetPinAction.actionName:SetPingReducer.self,
    DismissInstructionsAction.actionName:DismissInstructionsReducer.self
    
  ]
}
