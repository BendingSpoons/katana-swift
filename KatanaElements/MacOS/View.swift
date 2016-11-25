//
//  View.swift
//  Katana
//
//  Created by Andrea De Angelis on 25/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import AppKit
import Katana

public extension View {
  public struct Props: NodeDescriptionProps, Childrenable, Buildable {
    public var frame = CGRect.zero
    public var key: String?
    public var alpha: CGFloat = 1.0
    
    public var children: [AnyNodeDescription] = []
    
    public var backgroundColor = NSColor.white
    public var cornerRadius: Value = .zero
    public var borderWidth: Value = .zero
    public var borderColor = NSColor.clear
    
    public init() {}
    
    public static func == (lhs: Props, rhs: Props) -> Bool {
      if lhs.children.count + rhs.children.count > 0 {
        // Heuristic, we always rerender when there is at least 1 child
        return false
      }
      
      return
        lhs.frame == rhs.frame &&
          lhs.key == rhs.key &&
          lhs.alpha == rhs.alpha &&
          lhs.backgroundColor == rhs.backgroundColor &&
          lhs.cornerRadius == rhs.cornerRadius &&
          lhs.borderWidth == rhs.borderWidth &&
          lhs.borderColor == rhs.borderColor
    }
  }
}

public struct View: NodeDescription, NodeDescriptionWithChildren {
  public var props: Props
  
  public static func applyPropsToNativeView(props: Props,
                                            state: EmptyState,
                                            view: NSView,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    
    view.alpha = props.alpha
    view.frame = props.frame
    view.backgroundColor = props.backgroundColor
    view.layer?.cornerRadius = props.cornerRadius.scale(by: node.plasticMultipler)
    view.layer?.borderColor = props.borderColor.cgColor
    view.layer?.borderWidth = props.borderWidth.scale(by: node.plasticMultipler)
  }
  
  public static func childrenDescriptions(props: Props,
                                          state: EmptyState,
                                          update: @escaping (EmptyState)->(),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return props.children
  }
  
  public init(props: Props) {
    self.props = props
  }
  
  public init(props: Props, _ children: () -> [AnyNodeDescription]) {
    self.props = props
    self.props.children = children()
  }
}
