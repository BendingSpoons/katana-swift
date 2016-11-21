//
//  View.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import Katana_macOS
import KatanaElements_macOS
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
    
    return [
      Label(props: Label.Props.build({
        $0.setKey(Keys.label)
        $0.text = NSAttributedString(string: "test string")
        $0.textAlignment = .right
        $0.backgroundColor = NSColor.blue
      }))
    ]
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
    
    let label = views[.label]!
    label.fill(rootView)
  }
}

extension MacView {
  enum Keys {
    case label
  }
  
  struct Props: NodeDescriptionProps {
    var alpha: CGFloat = 1.0
    var frame: CGRect = .zero
    var key: String?
  }
}
