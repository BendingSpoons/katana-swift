//
//  MinesweeperSyncAction.swift
//  Minesweeper
//
//  Created by Andrea De Angelis on 14/11/2016.
//  Copyright © 2016 Andrea De Angelis. All rights reserved.
//

import Katana

protocol MinesweeperSyncAction: SyncAction {
  static func updatedState(currentState: inout MinesweeperState, action: Self)
}

extension MinesweeperSyncAction {
  static func updatedState(currentState: State, action: Self) -> State {
    guard var currentState = currentState as? MinesweeperState else { fatalError("unexpected app state") }
    self.updatedState(currentState: &currentState, action: action)
    return currentState
  }
}
