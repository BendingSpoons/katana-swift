//
//  MinesweeperCell.swift
//  Minesweeper
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana
import KatanaElements

// MARK: - NodeDescription
struct MinesweeperCell: PlasticNodeDescription, ConnectedNodeDescription {
  typealias StateType = EmptyState
  typealias PropsType = Props
  typealias NativeView = UIView
  typealias Keys = ChildrenKeys
  
  var props: Props
  
  static func childrenDescriptions(props: PropsType,
                                   state: StateType,
                                   update: @escaping (StateType) -> (),
                                   dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    func discloseMinesweeperCell() {
      dispatch(DiscloseCell(payload: (col: props.col, row: props.row)))
    }
    
    let disclosed: Bool = props.disclosed
    
    var labelText: String
    if props.hasMine {
      labelText = props.hasMine ? "+" : ""
    } else if props.minesNearby > 0 {
      labelText = String(props.minesNearby)
    } else {
      labelText = ""
    }
    
    let textColor = colorForNumber(props.minesNearby)
    let textAttributes = [NSForegroundColorAttributeName : textColor, NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
    
    let mineImage = Image(props: Image.Props.build({
      $0.setKey(Keys.mineImage)
      $0.image = #imageLiteral(resourceName: "mine")
      $0.backgroundColor = .red
    }))
    
    let label = Label(props: Label.Props.build({
      $0.setKey(Keys.label)
      $0.text = NSAttributedString(string: labelText, attributes: textAttributes)
      $0.textAlignment = .center
      $0.borderWidth = .scalable(1.0)
      $0.borderColor = .gray
    }))
    
    let button = Button(props: Button.Props.build({
      $0.setKey(Keys.button)
      $0.titleColors = [.normal: .gray]
      $0.backgroundColor = disclosed ? .white : .lightGray
      $0.touchHandlers = [TouchHandlerEvent.touchUpInside: discloseMinesweeperCell]
      $0.borderWidth = .scalable(1.0)
      $0.borderColor = .gray
    }))
    
    if props.hasMine && props.disclosed {
      return [mineImage]
    }
    return disclosed ? [label] : [label, button]
  }
  
  static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType) {
    let root = views.nativeView
    let label = views[.label]
    let button = views[.button]
    let mineImage = views[.mineImage]
    
    label?.fill(root)
    button?.fill(root)
    mineImage?.fill(root)
  }
  
  static func connect(props: inout PropsType, to storeState: MinesweeperState) {
    let column = props.col
    let row = props.row
    props.hasMine = storeState[column, row]
    props.disclosed = storeState.isDisclosed(col: column, row: row)
    props.minesNearby = storeState.minesNearbyCellAt(col: column, row: row)
  }
}

// MARK: Keys and Props
extension MinesweeperCell {
  enum ChildrenKeys {
    case button, label, mineImage
  }
  
  struct Props: NodeDescriptionProps, Buildable {
    public var frame: CGRect = .zero
    public var alpha: CGFloat = 1.0
    public var key: String?
    
    public var hasMine: Bool = false
    public var minesNearby: Int = 0
    public var disclosed: Bool = false
    public var col: Int = 0
    public var row: Int = 0
    
    static func == (lhs: PropsType, rhs: PropsType) -> Bool {
      return
        lhs.frame == rhs.frame &&
          lhs.alpha == rhs.alpha &&
          lhs.key == rhs.key &&
          lhs.hasMine == rhs.hasMine &&
          lhs.minesNearby == rhs.minesNearby &&
          lhs.disclosed == rhs.disclosed &&
          lhs.row == rhs.row &&
          lhs.col == rhs.col
    }
  }
}

// MARK: - Utils
extension MinesweeperCell {
  static func colorForNumber(_ number: Int) -> UIColor {
    switch number {
    case 1:
      return .blue
    case 2:
      return .green
    case 3:
      return .red
    default:
      return .red
    }
  }
}
