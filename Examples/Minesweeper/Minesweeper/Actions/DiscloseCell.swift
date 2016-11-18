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
  
  func updatedState(currentState: inout MinesweeperState) {
    let col = self.payload.col
    let row = self.payload.row
    currentState.disclose(col: col, row: row)
  }
}
