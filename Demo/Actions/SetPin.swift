//
//  SetPin.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct SetPin : SyncSmartAction, SmartActionWithSideEffect {
  var payload: [Int]
  
  static func reduce(state: inout AppState, action: SetPin) {
    state.pin = action.payload
  }
  
  static func sideEffect(action: SetPin, getState: @escaping () -> AppState, dispatch: StoreDispatch) {
    
  }

}
