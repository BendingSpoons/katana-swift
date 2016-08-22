//
//  Popup.swift
//  Katana
//
//  Created by Luca Querella on 13/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana
import UIKit

struct PopupProps : Equatable, Frameable {
  var frame: CGRect = CGRect.zero
  var children: [AnyNodeDescription] = []
  
  init (){}
  
  static func ==(lhs: PopupProps, rhs: PopupProps) -> Bool {
    return false
  }
}

struct Popup : NodeDescription {
  var props : PopupProps
  static var initialState = EmptyState()
  static var viewType = UIView.self
  
  init(props: PopupProps) {
    self.props = props
  }
  
  init(props: PopupProps, _ children: @noescape () -> [AnyNodeDescription]) {
    self.props = props
    self.props.children = children()
  }
  
  static func render(props: PopupProps,
                     state: EmptyState,
                     update: (EmptyState)->()) -> [AnyNodeDescription] {
    return [
      View(props: ViewProps()
        .frame(props.frame.size)
        .color(UIColor(white: 0, alpha: 0.8))
      ),
      
      View(props: ViewProps()
        .frame(CGRect(x: 25, y: 40, width: 270, height: 400))
        .color(.white)
        .cornerRadius(10)
        .children(props.children)
      )
    ]
  }
  
}
