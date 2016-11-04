//
//  View.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

struct ViewProps: NodeProps, Keyable, Childrenable {
  var frame = CGRect.zero
  var key: String?
  var children: [AnyNodeDescription] = []
  
  var backgroundColor = UIColor.white
  
  init() {}
  
  init<Key>(_ key: Key) {
    self.setKey(key)
  }
  
  init<Key>(_ key: Key, frame: CGRect) {
    self.setKey(key)
    self.frame = frame
  }
  
  init(_ frame: CGRect) {
    self.frame = frame
  }
  
  static func == (lhs: ViewProps, rhs: ViewProps) -> Bool {
    if lhs.children.count + rhs.children.count > 1 {
      return false
    }

    return
      lhs.frame == rhs.frame &&
        lhs.key == rhs.key &&
        lhs.backgroundColor == rhs.backgroundColor
  }
}


struct View: NodeDescription, NodeDescriptionWithChildren {
  
  public var props: ViewProps
  
  public static func applyPropsToNativeView(props: ViewProps,
                                            state: EmptyState,
                                            view: UIView,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    
    view.frame = props.frame
    view.backgroundColor = props.backgroundColor
  }
  
  public static func childrenDescriptions(props: ViewProps,
                                          state: EmptyState,
                                          update: @escaping (EmptyState)->(),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return props.children
  }
  
  public init(props: ViewProps) {
    self.props = props
  }
  
  public init(props: ViewProps, _ children: () -> [AnyNodeDescription]) {
    self.props = props
    self.props.children = children()
  }
}
