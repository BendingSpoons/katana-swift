//
//  MineFieldState.swift
//  Katana
//
//  Created by Luca Querella on 24/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

enum MineFieldDifficulty {
  case easy, medium, hard
}

struct MineFieldState: State {
  var gameOver: Bool
  let rows: Int
  let cols: Int
  var mines: [Bool]
  var disclosed: [Bool]
  
  
  init() {
    self.init(difficulty: .hard)
  }
  
  init(difficulty: MineFieldDifficulty) {
    switch difficulty {
    case .easy:
      self.init(cols: 9, rows: 9, mines: 10)
    case .medium:
      self.init(cols: 16, rows: 16, mines: 40)
    case .hard:
      self.init(cols: 16, rows: 30, mines: 99)
    }
  }
  
  private init(cols: Int, rows: Int, mines: Int) {
    self.gameOver = false
    self.rows = rows
    self.cols = cols
    self.mines = Array(repeating: false, count: rows * cols)
    self.disclosed = Array(repeating: false, count: rows * cols)
    
    var i = 0
    while i < mines {
      let r = Int(arc4random_uniform(UInt32(rows)))
      let c = Int(arc4random_uniform(UInt32(cols)))
      if( self[c, r] != true) {
        i += 1
        self[c, r] = true
      }
    }
    
    
  }
  
  func minesNearbyCellAt(col: Int, row: Int) -> Int {
    var mines = 0
    for index in self.nearbyCellsIndicesAt(col: col, row: row) {
      if(self[index.0, index.1]) {
        mines += 1
      }
    }
    return mines
  }
  
  func nearbyCellsIndicesAt(col: Int, row: Int) -> [(Int, Int)] {
    var indices: [(Int, Int)] = []
    let startCol = col - 1
    let endCol = col + 1
    let startRow = row - 1
    let endRow = row + 1
    for currentCol in startCol...endCol {
      for currentRow in startRow...endRow {
        
        guard currentCol >= 0 && currentCol < cols else {
          continue
        }
        
        guard currentRow >= 0 && currentRow < rows else {
          continue
        }
        
        if currentRow == row && currentCol == col {
          continue
        }
        
        indices.append((currentCol, currentRow))
      }
    }
    return indices
  }
  
  mutating func disclose(col: Int, row: Int) {
    disclosed[cols*row+col] = true
  }
  
  func isDisclosed(col: Int, row: Int) -> Bool {
    return disclosed[cols*row+col]
  }
  
  subscript(col: Int, row: Int) -> Bool {
    get { return mines[cols * row + col] }
    set { mines[cols*row+col] = newValue }
  }
  
  static func == (lhs: MineFieldState, rhs: MineFieldState) -> Bool {
    return lhs.mines == rhs.mines && lhs.disclosed == rhs.disclosed
  }
}
