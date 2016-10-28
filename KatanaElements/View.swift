//
//  View.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public struct ViewProps: NodeProps, Keyable, Childrenable, Colorable, TouchDisableable, CornerRadiusable, Bordable {
  public var frame = CGRect.zero
  public var color = UIColor.white
  public var touchDisabled =  false
  public var cornerRadius = CGFloat(0)
  public var borderColor = UIColor.black
  public var borderWidth = CGFloat(0)
  public var key: String?
  public var children: [AnyNodeDescription] = []
 
  public init() {}

  public static func == (lhs: ViewProps, rhs: ViewProps) -> Bool {
    if lhs.children.count + rhs.children.count > 0 {
      // Euristic, we always rerender when there is at least 1 child
      return false
    }
    
    return lhs.frame == rhs.frame &&
      lhs.color == rhs.color &&
      lhs.touchDisabled == rhs.touchDisabled &&
      lhs.cornerRadius == rhs.cornerRadius
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
    view.backgroundColor = props.color
    view.isUserInteractionEnabled = !props.touchDisabled
    view.clipsToBounds = true
    view.layer.cornerRadius = props.cornerRadius
    view.layer.borderWidth = props.borderWidth
    view.layer.borderColor = props.borderColor.cgColor
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
