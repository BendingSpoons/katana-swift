//
//  StartGame.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct StartGame: SyncAction {
  var payload: MinesweeperState.Difficulty
  
  static func updatedState(currentState: State, action: StartGame) -> State {
    return MinesweeperState(difficulty: action.payload)
  }
}
