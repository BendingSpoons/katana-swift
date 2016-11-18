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
  
  func updatedState( currentState: inout MinesweeperState) {
    currentState = MinesweeperState(difficulty: self.payload)
  }
}
