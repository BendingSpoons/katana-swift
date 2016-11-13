//
//  DiscloseCell.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct DiscloseCell: SyncAction {
  var payload: (col: Int, row: Int)
  
  static func updatedState(currentState: State, action: DiscloseCell) -> State {
    let currentState = currentState as! MinesweeperState
    guard !currentState.gameOver else { return currentState }
    var newState = currentState
    
    let col = action.payload.col
    let row = action.payload.row
    var cellsToDisclose = [(col, row)]
    
    while cellsToDisclose.count > 0 {
      let index = cellsToDisclose.removeFirst()
      if(!newState.isDisclosed(col: index.0, row: index.1 )) {
        newState.disclose(col: index.0, row: index.1)
        if(newState[index.0, index.1]) {
          newState.gameOver = true
          return newState
        }
        if(newState.minesNearbyCellAt(col: index.0, row: index.1) == 0) {
          cellsToDisclose.append(contentsOf: currentState.nearbyCellsIndicesAt(col: index.0, row: index.1))
        }
        
      }
    }
    newState.disclose(col: col, row: row)
    return newState
  }
}
