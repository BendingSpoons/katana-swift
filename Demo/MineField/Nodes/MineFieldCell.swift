//
//  MineFieldCell.swift
//  Katana
//
//  Created by Andrea De Angelis on 07/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public protocol HasMinable {
  var hasMine: Bool { get set }
  func hasMine(_ hasMine: Bool) -> Self
}

extension HasMinable {
  func hasMine(_ hasMine: Bool) -> Self {
    var copy = self
    copy.hasMine = hasMine
    return copy
  }
}

struct MineFieldCellProps: NodeProps, Keyable, HasMinable {
  public var frame: CGRect = CGRect.zero
  public var key: String?
  public var hasMine: Bool = false
  public var minesNearby: Int = 0
  public var disclosed: Bool = false
  public var col: Int = 0
  public var row: Int = 0
  
  public func minesNearby(minesNearby: Int) -> MineFieldCellProps {
    var copy = self
    copy.minesNearby = minesNearby
    return copy
  }
  
  public func disclosed(_ disclosed: Bool) -> MineFieldCellProps {
    var copy = self
    copy.disclosed = disclosed
    return copy
  }
  
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
  
  // if I remove this I get slow updates (ok, it will redraw every MineFieldCell on every update but it's not enough to justify it)
  static func ==(lhs: MineFieldCellProps, rhs: MineFieldCellProps) -> Bool {
    return
      lhs.frame == rhs.frame &&
        lhs.hasMine == rhs.hasMine &&
        lhs.minesNearby == rhs.minesNearby &&
        lhs.disclosed == rhs.disclosed &&
        lhs.row == rhs.row &&
        lhs.col == rhs.col
  }
}

enum MineFieldCellKeys: String,NodeDescriptionKeys {
  case button
  case text
}


struct MineFieldCell : NodeDescription, ConnectedNodeDescription, PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize  {
  
  var props : MineFieldCellProps
  
  static var referenceSize: CGSize {
    return CGSize(width: 20, height: 20)
  }
  
  static func render(props: MineFieldCellProps,
                     state: EmptyState,
                     update: @escaping  (EmptyState) -> (),
                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    func discloseMineFieldCell() {
      dispatch(DiscloseCell(payload: (props.col, props.row)))
    }
    
    let disclosed: Bool = props.disclosed
    
    var text: String
    if(props.hasMine) {
      text = props.hasMine ? "+" : ""
    }
    else if(props.minesNearby > 0) {
      text = String(props.minesNearby)
    }
    else {
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
    
    if(disclosed) {
      return [textNode]
    }
    else {
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
  
  static func connect(props: inout MineFieldCellProps, storageState: MineFieldState) {
    let column = props.col
    let row = props.row
    props.hasMine = storageState[column,row]
    props.disclosed = storageState.isDisclosed(col: column, row: row)
    props.minesNearby = storageState.minesNearbyCellAt(col: column, row: row)
  }
}
