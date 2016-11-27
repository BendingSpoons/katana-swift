//
//  Button.swift
//  Katana
//
//  Created by Andrea De Angelis on 25/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import AppKit
import Katana

public typealias ClickHandlerClosure = () -> ()

public extension Button {
  public struct Props: NodeDescriptionProps, Childrenable, Buildable {
    public var frame = CGRect.zero
    public var key: String?
    public var alpha: CGFloat = 1.0
    
    public var children: [AnyNodeDescription] = []
    
    public var backgroundColor: NSColor = .white
    public var backgroundHighlightedColor: NSColor?
    public var cornerRadius: Value = .zero
    public var borderWidth: Value = .zero
    public var borderColor = NSColor.clear
    
    public var title: NSAttributedString = NSAttributedString()
    public var clickHandler: ClickHandlerClosure?;
    
    public init() {}
    
    public static func == (lhs: Props, rhs: Props) -> Bool {
      // We can't detect whether clickHandler is changed
      return false
    }
  }
}

public struct Button: NodeDescription, NodeDescriptionWithChildren {
  public var props: Props
  
  public static func applyPropsToNativeView(props: Props,
                                            state: EmptyState,
                                            view: NativeButton,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    view.wantsLayer = true
    view.setButtonType(NSMomentaryLightButton)
    view.isBordered = false
    view.alpha = props.alpha
    view.frame = props.frame
    view.backgroundNormalColor = props.backgroundColor
    view.backgroundHighlightedColor = props.backgroundHighlightedColor ?? props.backgroundColor
    view.layer?.cornerRadius = props.cornerRadius.scale(by: node.plasticMultipler)
    view.layer?.borderColor = props.borderColor.cgColor
    view.layer?.borderWidth = props.borderWidth.scale(by: node.plasticMultipler)
    view.attributedTitle = props.title
    view.clickHandler = props.clickHandler
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
