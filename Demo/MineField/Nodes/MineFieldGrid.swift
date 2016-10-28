//
//  MineFieldGrid.swift
//  Katana
//
//  Created by Andrea De Angelis on 07/09/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

extension UIColor {
  static var randomColor: UIColor {
    return UIColor(red: CGFloat(arc4random_uniform(256)) / 255.0,
                   green: CGFloat(arc4random_uniform(256)) / 255.0,
                   blue: CGFloat(arc4random_uniform(256)) / 255.0,
                   alpha: 1.0)
  }
  
  
}

struct MineFieldGridProps: NodeProps, Keyable {
  public var frame: CGRect = CGRect.zero
  public var key: String?
  public var cols: Int = 0
  public var rows: Int = 0
  
  
  static func == (lhs: MineFieldGridProps, rhs: MineFieldGridProps) -> Bool {
    return
      lhs.frame == rhs.frame && lhs.cols == rhs.cols && lhs.rows == rhs.rows
  }
}


enum MineFieldGridKeys {
  case button(column: Int, row: Int)
}


struct MineFieldGrid: NodeDescription, ConnectedNodeDescription, PlasticNodeDescription {
  
  var props: MineFieldGridProps

  static func childrenDescriptions(props: MineFieldGridProps,
                     state: EmptyState,
                     update: @escaping  (EmptyState) -> (),
                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    var nodes = [AnyNodeDescription]()
    for column in 0..<props.cols {
      for row in 0..<props.rows {
        

        
        nodes.append(MineFieldCell(props: MineFieldCellProps()
          .key(MineFieldGridKeys.button(column:column, row:row))
          .col(column)
          .row(row)
        ))
      }
    }
    
    
    return nodes
    
  }
  
  
  static func layout(views: ViewsContainer<MineFieldGridKeys>, props: MineFieldGridProps, state: EmptyState) {
    
    let root = views.nativeView
    var leftAnchor = root.left
    var topAnchor = root.top
    
    for column in 0..<props.cols {
      var node: PlasticView!
      for row in 0..<props.rows {
        node = views[.button(column: column, row: row)]!
        node.left = leftAnchor
        node.top = topAnchor
        node.width = .scalable(40)
        node.height = .scalable(40)
        topAnchor = node.bottom
      }
      topAnchor = root.top
      leftAnchor = node.right
    }
  }
  
  static func connect(props: inout MineFieldGridProps, storageState: MineFieldState) {
    props.cols = storageState.cols
    props.rows = storageState.rows
  }
}
