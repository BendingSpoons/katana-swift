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

struct AppStateActions {
  typealias SetPinActionType = SyncAction<[Int]>
  static let SetPinAction = SyncActionCreator<[Int]>(withName: "SetPin")
  
  typealias DismissInstructionsActionType = SyncAction<Bool>
  static let DismissInstructionsAction = SyncActionCreator<Bool>(withName: "DismissInstructions")

}

struct SetPingReducer : SyncReducer {
  static func reduceSync(action: AppStateActions.SetPinActionType, state: AppState) -> AppState {
    var state = state
    state.pin = action.payload
    return state
  }
}

struct DismissInstructionsReducer : SyncReducer {
  static func reduceSync(action: AppStateActions.DismissInstructionsActionType, state: AppState) -> AppState {
    var state = state
    state.instructionShown = true
    return state
  }
}


struct AppReducer : ReducerCombiner   {
  
  static var initialState = AppState(pin: nil, instructionShown: false)
  static var reducers : [String:AnyReducer.Type] = [
    AppStateActions.SetPinAction.actionName:SetPingReducer.self,
    AppStateActions.DismissInstructionsAction.actionName:DismissInstructionsReducer.self

  ]
}
