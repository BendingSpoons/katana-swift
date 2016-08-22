//
//  CellNodeDescription.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol CellNodeDescription: NodeDescription {
  associatedtype NativeView: CellNativeView
  associatedtype State: Equatable, Highlightable
  
  static var nativeViewType : NativeView.Type { get }
  static var initialState: State { get }
}

public extension CellNodeDescription {
  public static func applyPropsToNativeView(props: Props, state: State, view: NativeView, update: (State)->())  {
    view.frame = props.frame
    
    view.update = { (highlighted: Bool) in
      var newState = state
      newState.highlighted = highlighted
      update(newState)
    }
  }
  
  public static func applyPropsToNativeView(props: Props,
                                            state: State,
                                            view: NativeView,
                                            update: (State)->(),
                                            concreteNode: AnyNode) ->  Void {
    self.applyPropsToNativeView(props: props, state: state, view: view, update: update)
  }
}
