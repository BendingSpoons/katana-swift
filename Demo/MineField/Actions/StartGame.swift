//
//  StartEasyGame.swift
//  Katana
//
//  Created by Andrea De Angelis on 08/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana


struct StartGame: SyncSmartAction {
  var payload: MineFieldDifficulty
  
  static func reduce(state: inout MineFieldState, action: StartGame) {
    state = MineFieldState(difficulty: action.payload)
  }
  
}
