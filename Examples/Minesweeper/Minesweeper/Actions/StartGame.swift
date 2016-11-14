//
//  StartGame.swift
//  Minesweeper
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct StartGame: MinesweeperSyncAction {
  var payload: MinesweeperState.Difficulty
  
  static func updatedState( currentState: inout MinesweeperState, action: StartGame) {
    currentState = MinesweeperState(difficulty: action.payload)
  }
}
