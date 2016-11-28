//
//  View.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit
import Katana

public extension Label {
  public struct Props: NodeDescriptionProps, Buildable {
    public var frame = CGRect.zero
    public var key: String?
    public var alpha: CGFloat = 1.0
    
    public var backgroundColor = UIColor.white
    public var cornerRadius: Value = .zero
    public var borderWidth: Value = .zero
    public var borderColor = UIColor.clear
    public var clipsToBounds = true
    public var isUserInteractionEnabled = false
    public var text: NSAttributedString?
    public var textAlignment: NSTextAlignment = .left
    public var lineBreakMode: NSLineBreakMode = .byClipping
    public var numberOfLines: Int = 1
    public var adjustsFontSizeToFitWidth: Bool = true
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
          lhs.clipsToBounds == rhs.clipsToBounds &&
          lhs.isUserInteractionEnabled == rhs.isUserInteractionEnabled &&
          lhs.text == rhs.text &&
          lhs.textAlignment == rhs.textAlignment &&
          lhs.lineBreakMode == rhs.lineBreakMode &&
          lhs.numberOfLines == rhs.numberOfLines &&
          lhs.adjustsFontSizeToFitWidth == rhs.adjustsFontSizeToFitWidth &&
          lhs.allowsDefaultTighteningForTruncation == rhs.allowsDefaultTighteningForTruncation &&
          lhs.minimumScaleFactor == rhs.minimumScaleFactor
    }
    
    public init() {}
  }
}


public struct Label: NodeDescription {
  public typealias NativeView = UILabel

  public var props: Props
  
  public static func applyPropsToNativeView(props: Props,
                                            state: EmptyState,
                                            view: UILabel,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {

    view.frame = props.frame
    view.alpha = props.alpha
    view.backgroundColor = props.backgroundColor
    view.layer.cornerRadius = props.cornerRadius.scale(by: node.plasticMultiplier)
    view.layer.borderWidth = props.borderWidth.scale(by: node.plasticMultiplier)
    view.layer.borderColor = props.borderColor.cgColor
    view.clipsToBounds = props.clipsToBounds
    view.isUserInteractionEnabled = props.isUserInteractionEnabled
    view.attributedText = props.text
    view.textAlignment = props.textAlignment
    view.lineBreakMode = props.lineBreakMode
    view.numberOfLines = props.numberOfLines
    view.adjustsFontSizeToFitWidth = props.adjustsFontSizeToFitWidth
    view.minimumScaleFactor = props.minimumScaleFactor
    
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
