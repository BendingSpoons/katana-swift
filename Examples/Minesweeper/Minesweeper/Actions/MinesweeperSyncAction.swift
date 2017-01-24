//
//  MinesweeperSyncAction.swift
//  Minesweeper
//
//  Created by Andrea De Angelis on 14/11/2016.
//  Copyright © 2016 Andrea De Angelis. All rights reserved.
//

import Katana

protocol MinesweeperSyncAction: Action {
  func updatedState(currentState: inout MinesweeperState)
}

extension MinesweeperSyncAction {
  func updatedState(currentState: State) -> State {
    guard var currentState = currentState as? MinesweeperState else { fatalError("unexpected app state") }
    self.updatedState(currentState: &currentState)
    return currentState
  }
}
