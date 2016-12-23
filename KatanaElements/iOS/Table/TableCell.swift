//
//  CellNodeDescription.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana

public protocol AnyTableCell: AnyNodeDescription {
  static func anyDidTap(dispatch: StoreDispatch, props: Any, indexPath: IndexPath)
}

public protocol TableCell: NodeDescription, AnyTableCell {
  associatedtype NativeView: NativeTableCell = NativeTableCell
  associatedtype StateType: Highlightable = EmptyHighlightableState

  static func didTap(dispatch: StoreDispatch, props: PropsType, indexPath: IndexPath)
}

public extension TableCell {
  public static func applyPropsToNativeView(props: PropsType,
                                            state: StateType,
                                            view: NativeView,
                                            update: @escaping (StateType)->(),
                                            node: AnyNode) {

    view.frame = props.frame

    view.update = { (highlighted: Bool) in
      var newState = state
      newState.highlighted = highlighted
      update(newState)
    }
  }

  public static func anyDidTap(dispatch: StoreDispatch, props: Any, indexPath: IndexPath) {
    if let p = props as? PropsType {
      self.didTap(dispatch: dispatch, props: p, indexPath: indexPath)
    }
  }
}

public class NativeTableCell: UIView {
  var update: ((Bool) -> ())?

  func setHighlighted(_ highlighted: Bool) {
    if let update = self.update {
      update(highlighted)
    }
  }
}
