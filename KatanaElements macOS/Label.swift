//
//  View.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana_macOS
import AppKit

public extension Label {
  public struct Props: NodeDescriptionProps, Buildable {
    public var frame = CGRect.zero
    public var key: String?
    public var alpha: CGFloat = 1.0
    
    public var backgroundColor = NSColor.white
    public var cornerRadius: Value = .zero
    public var borderWidth: Value = .zero
    public var borderColor = NSColor.clear
    public var text: NSAttributedString?
    public var textAlignment: NSTextAlignment = .left
    public var lineBreakMode: NSLineBreakMode = .byClipping
    public var numberOfLines: Int = 1
    public var allowsDefaultTighteningForTruncation: Bool = true
    public var minimumScaleFactor: CGFloat = 0.10
    
    public static func == (lhs: Props, rhs: Props) -> Bool {
      return
        lhs.frame == rhs.frame &&
          lhs.key == rhs.key &&
          lhs.alpha == rhs.alpha &&
          lhs.backgroundColor == rhs.backgroundColor &&
          lhs.cornerRadius == rhs.cornerRadius &&
          lhs.borderWidth == rhs.borderWidth &&
          lhs.borderColor == rhs.borderColor &&
          lhs.text == rhs.text &&
          lhs.textAlignment == rhs.textAlignment &&
          lhs.lineBreakMode == rhs.lineBreakMode &&
          lhs.numberOfLines == rhs.numberOfLines
    }
    
    public init() {}
  }
}


public struct Label: NodeDescription {
  public typealias NativeView = NSTextField
  
  public var props: Props
  
  public static func applyPropsToNativeView(props: Props,
                                            state: EmptyState,
                                            view: NSTextField,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    // properties to make the NSTextField to appear equivalent to a UILabel
    view.isBezeled = false
    view.isEditable = false
    view.isSelectable = false
    
    // other properties
    
    view.frame = props.frame
    view.alpha = props.alpha
    view.backgroundColor = props.backgroundColor
    view.layer?.cornerRadius = props.cornerRadius.scale(by: node.plasticMultipler)
    view.layer?.borderWidth = props.borderWidth.scale(by: node.plasticMultipler)
    view.layer?.borderColor = props.borderColor.cgColor
    view.alignment = props.textAlignment
    let attributedString = props.text ?? NSAttributedString(string: "")
    view.attributedStringValue = attributedString
    view.lineBreakMode = props.lineBreakMode
    view.maximumNumberOfLines = props.numberOfLines
    
    if #available(iOS 9.0, *) {
      view.allowsDefaultTighteningForTruncation = props.allowsDefaultTighteningForTruncation
    }
  }
  
  public static func childrenDescriptions(props: Props,
                                          state: EmptyState,
                                          update: @escaping (EmptyState)->(),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
  
  public init(props: Props) {
    self.props = props
  }
}
