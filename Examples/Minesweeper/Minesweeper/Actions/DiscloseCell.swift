//
//  DiscloseCell.swift
//  Minesweeper
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct DiscloseCell: MinesweeperSyncAction {
  var payload: (col: Int, row: Int)
  
  static func updatedState(currentState: inout MinesweeperState, action: DiscloseCell) {
    let col = action.payload.col
    let row = action.payload.row
    currentState.disclose(col: col, row: row)
  }
}
