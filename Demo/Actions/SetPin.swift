//
//  SetPin.swift
//  Katana
//
//  Created by Luca Querella on 29/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct SetPin : SyncAction {
  
  var payload: [Int]
  
  static func reduce(state: inout AppState, action: SetPin) {
    state.pin = action.payload
  }
}
