//
//  MineFieldCell.swift
//  Katana
//
//  Created by Andrea De Angelis on 07/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana
import KatanaElements

struct MineFieldCellProps: NodeProps, Keyable {
  public var frame: CGRect = CGRect.zero
  public var key: String?
  public var hasMine: Bool = false
  public var minesNearby: Int = 0
  public var disclosed: Bool = false
  public var col: Int = 0
  public var row: Int = 0
  
  
  public func col(_ col: Int) -> MineFieldCellProps {
    var copy = self
    copy.col = col
    return copy
  }
  
  public func row(_ row: Int) -> MineFieldCellProps {
    var copy = self
    copy.row = row
    return copy
  }
  
  static func == (lhs: MineFieldCellProps, rhs: MineFieldCellProps) -> Bool {
    return
      lhs.frame == rhs.frame &&
        lhs.hasMine == rhs.hasMine &&
        lhs.minesNearby == rhs.minesNearby &&
        lhs.disclosed == rhs.disclosed &&
        lhs.row == rhs.row &&
        lhs.col == rhs.col
  }
}

enum MineFieldCellKeys {
  case button
  case text
}


struct MineFieldCell: NodeDescription, ConnectedNodeDescription, PlasticNodeDescription {
  
  var props: MineFieldCellProps

  static func childrenDescriptions(props: MineFieldCellProps,
                     state: EmptyState,
                     update: @escaping  (EmptyState) -> (),
                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    func discloseMineFieldCell() {
      dispatch(DiscloseCell(payload: (props.col, props.row)))
    }
    
    let disclosed: Bool = props.disclosed
    
    var text: String
    if props.hasMine {
      text = props.hasMine ? "+" : ""
    } else if props.minesNearby > 0 {
      text = String(props.minesNearby)
    } else {
      text = ""
    }
    
    
    let textNode = Text(props: TextProps()
      .key(MineFieldCellKeys.text)
      .text(text, fontSize: 15)
    )
    
    let buttonNode = Button(props: ButtonProps()
      .key(MineFieldCellKeys.button)
      .color(.gray)
      .color(UIColor(0xC42900), state: .highlighted)
      .onTap(discloseMineFieldCell)
    )
    
    if disclosed {
      return [textNode]
    } else {
      return [textNode, buttonNode]
    }
  }
  
  
  static func layout(views: ViewsContainer<MineFieldCellKeys>, props: MineFieldCellProps, state: EmptyState) {
    
    let root = views.nativeView
    let text = views[.text]
    let button = views[.button]
    
    text?.fill(root)
    button?.fill(root)
  }
  
  static func connect(props: inout MineFieldCellProps, to storageState: MineFieldState) {
    let column = props.col
    let row = props.row
    props.hasMine = storageState[column, row]
    props.disclosed = storageState.isDisclosed(col: column, row: row)
    props.minesNearby = storageState.minesNearbyCellAt(col: column, row: row)
  }
}
