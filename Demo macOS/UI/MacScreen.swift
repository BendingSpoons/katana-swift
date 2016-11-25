//
//  MacView.swift
//  Katana
//
//  Created by Andrea De Angelis on 25/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import KatanaElements
import AppKit

struct MacScreen: NodeDescription, PlasticNodeDescription, PlasticReferenceSizeable {
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
      View(props: View.Props.build({
        $0.setKey(Keys.view)
        $0.backgroundColor = NSColor.purple
        $0.cornerRadius = .scalable(100.0)
        $0.borderWidth = .scalable(20.0)
        $0.borderColor = NSColor.red
      })),
      Button(props: Button.Props.build({
        $0.setKey(Keys.button)
      }))
    ]
  }
  
  public static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType) {
    let rootView = views.nativeView
    
    let view = views[.view]!
    let button = views[.button]!
    
    view.fill(rootView)
    button.left = rootView.left
    button.top = rootView.top
    button.width = .scalable(100)
    button.height = .scalable(40)
  }
}

extension MacScreen {
  enum Keys {
    case view
    case button
  }
  
  struct Props: NodeDescriptionProps, Buildable {
    var alpha: CGFloat = 1.0
    var frame: CGRect = .zero
    var key: String?
  }
}
