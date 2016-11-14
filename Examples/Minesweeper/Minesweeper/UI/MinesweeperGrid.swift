//
//  MinesweeperGrid.swift
//  Minesweeper
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana
import KatanaElements

// MARK: - NodeDescription
struct MinesweeperGrid: ConnectedNodeDescription, PlasticNodeDescription {
  typealias StateType = EmptyState
  typealias PropsType = Props
  typealias NativeView = UIView
  typealias Keys = ChildrenKeys
  
  var props: Props
  
  static func childrenDescriptions(props: PropsType,
                                   state: StateType,
                                   update: @escaping (StateType) -> (),
                                   dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    var nodes = [AnyNodeDescription]()
    for column in 0..<props.cols {
      for row in 0..<props.rows {
        let minesweeperCell = MinesweeperCell(props: MinesweeperCell.Props.build({
          $0.setKey(Keys.button(column: column, row: row))
          $0.col = column
          $0.row = row
        }))
        nodes.append(minesweeperCell)
      }
    }
    return nodes
  }
  
  static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType) {
    let root = views.nativeView
    var leftAnchor = root.left
    var topAnchor = root.top
    
    for column in 0..<props.cols {
      var node: PlasticView!
      for row in 0..<props.rows {
        node = views[.button(column: column, row: row)]!
        node.left = leftAnchor
        node.top = topAnchor
        node.width = .scalable(50)
        node.height = .scalable(50)
        topAnchor = node.bottom
      }
      topAnchor = root.top
      leftAnchor = node.right
    }
  }
  
  static func connect(props: inout PropsType, to storeState: MinesweeperState) {
    props.cols = storeState.cols
    props.rows = storeState.rows
  }
}

// MARK: Keys and Props
extension MinesweeperGrid {
  enum ChildrenKeys {
    case button(column: Int, row: Int)
  }
  
  struct Props: NodeDescriptionProps, Buildable {
    public var frame: CGRect = .zero
    public var alpha: CGFloat = 1.0
    public var key: String?
    
    public var cols: Int = 0
    public var rows: Int = 0
    
    static func == (lhs: PropsType, rhs: PropsType) -> Bool {
      return
        lhs.frame == rhs.frame &&
        lhs.alpha == rhs.alpha &&
        lhs.key == rhs.key &&
        lhs.cols == rhs.cols &&
        lhs.rows == rhs.rows
    }
  }
}
