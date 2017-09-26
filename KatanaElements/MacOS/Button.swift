//
//  Button.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import AppKit
import Katana

public extension Button {
  public struct Props: NodeDescriptionProps, Childrenable, Buildable {
    public var frame = CGRect.zero
    public var key: String?
    public var alpha: CGFloat = 1.0

    public var children: [AnyNodeDescription] = []

    public var backgroundColor: NSColor = .white
    public var backgroundHighlightedColor: NSColor?
    public var borderColor: NSColor = .clear
    public var borderWidth: Value = .zero
    public var cornerRadius: Value = .zero
    public var title: NSAttributedString = NSAttributedString()
    public var toolTip: String?
    public var image: NSImage?
    public var highlightedImage: NSImage?
    public var clickHandler: ClickHandlerClosure?
    public var isEnabled: Bool = true
    public var type: NSButton.ButtonType = .momentaryChange
    
    public init() {}

    public static func == (lhs: Props, rhs: Props) -> Bool {
      // We can't detect whether clickHandler is changed or not
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
    view.setButtonType(props.type)
    view.isBordered = false
    view.alpha = props.alpha
    view.frame = props.frame
    view.image = props.image
    view.isEnabled = props.isEnabled
    view.alternateImage = props.highlightedImage
    view.backgroundColor = props.backgroundColor
    view.backgroundHighlightedColor = props.backgroundHighlightedColor ?? props.backgroundColor
    view.attributedTitle = props.title
    view.clickHandler = props.clickHandler
    view.borderColor = props.borderColor
    view.borderWidth = props.borderWidth.scale(by: node.plasticMultiplier)
    view.cornerRadius = props.cornerRadius.scale(by: node.plasticMultiplier)
    view.toolTip = props.toolTip
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
