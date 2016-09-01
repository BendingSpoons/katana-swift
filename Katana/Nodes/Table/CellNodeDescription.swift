//
//  CellNodeDescription.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyCellNodeDescription: AnyNodeDescription {
  static func anyDidTap(dispatch: StoreDispatch, props: Any, indexPath: IndexPath)
}

public protocol CellNodeDescription: NodeDescription, AnyCellNodeDescription {
  associatedtype NativeView: CellNativeView = CellNativeView
  associatedtype State: Highlightable = EmptyHighlightableState

  static func didTap(dispatch: StoreDispatch, props: Props, indexPath: IndexPath)
}

public extension CellNodeDescription {

  public static func applyPropsToNativeView(props: Props,
                                            state: State,
                                            view: NativeView,
                                            update: @escaping (State)->(),
                                            concreteNode: AnyNode) ->  Void {

    view.frame = props.frame
    
    view.update = { (highlighted: Bool) in
      var newState = state
      newState.highlighted = highlighted
      update(newState)
    }
  
  }
  
  
  public static func anyDidTap(dispatch: StoreDispatch, props: Any, indexPath: IndexPath) {
    if let p = props as? Props {
      self.didTap(dispatch: dispatch, props: p, indexPath: indexPath)
    }
  }
}
