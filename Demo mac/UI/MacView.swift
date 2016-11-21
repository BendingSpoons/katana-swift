//
//  View.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana
import AppKit

struct MacView: NodeDescription, PlasticNodeDescription {
  typealias StateType = EmptyState
  typealias PropsType = Props
  typealias NativeView = NSView
  
  var props: PropsType
  
  static var referenceSize = CGSize(width: 500, height: 500)
  
  public static func childrenDescriptions(props: PropsType,
                                          state: StateType,
                                          update: @escaping (StateType) -> (),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    return []
  }
  
  static func applyPropsToNativeView(props: PropsType,
                                     state: StateType,
                                     view: NativeView,
                                     update: @escaping (StateType)->(),
                                     node: AnyNode){
    view.frame = props.frame
    view.alpha = props.alpha
    view.backgroundColor = .green
  }
  
  public static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType) {
    let rootView = views.nativeView
    
    let view = views[.view]
    view?.fill(rootView)
  }
}

extension MacView {
  enum Keys {
    case view
  }
  
  struct Props: NodeDescriptionProps {
    var alpha: CGFloat = 1.0
    var frame: CGRect = .zero
    var key: String?
  }
}
