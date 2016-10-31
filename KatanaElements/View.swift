//
//  View.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public struct ViewProps: NodeProps, Keyable, Childrenable, Buildable {
  public var frame = CGRect.zero
  public var key: String?
  public var children: [AnyNodeDescription] = []
  
  public var backgroundColor = UIColor.white
  public var cornerRadius: Value = .zero
  public var borderWidth: Value = .zero
  public var borderColor = UIColor.clear
  public var clipsToBounds = true
  public var isUserInteractionEnabled = false
 
  public init() {}

  public static func == (lhs: ViewProps, rhs: ViewProps) -> Bool {
    if lhs.children.count + rhs.children.count > 0 {
      // Heuristic, we always rerender when there is at least 1 child
      return false
    }
    
    return
      lhs.frame == rhs.frame &&
      lhs.key == rhs.key &&
      lhs.backgroundColor == rhs.backgroundColor &&
      lhs.cornerRadius == rhs.cornerRadius &&
      lhs.borderWidth == rhs.borderWidth &&
      lhs.borderColor == rhs.borderColor &&
      lhs.clipsToBounds == rhs.clipsToBounds &&
      lhs.isUserInteractionEnabled == rhs.isUserInteractionEnabled
  }
}


public struct View: NodeDescription, NodeWithChildrenDescription {
  
  public var props: ViewProps

  public static func applyPropsToNativeView(props: ViewProps,
                                            state: EmptyState,
                                            view: UIView,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    
    view.frame = props.frame
    view.backgroundColor = props.backgroundColor
    view.layer.cornerRadius = props.cornerRadius.scale(node.plasticMultipler)
    view.layer.borderColor = props.borderColor.cgColor
    view.layer.borderWidth = props.borderWidth.scale(node.plasticMultipler)
    view.clipsToBounds = props.clipsToBounds
    view.isUserInteractionEnabled = props.isUserInteractionEnabled
  }
  
  public static func render(props: ViewProps,
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
