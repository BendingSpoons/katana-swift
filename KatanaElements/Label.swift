//
//  View.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public struct LabelProps: NodeProps, Keyable, Buildable {
  public var frame = CGRect.zero
  public var key: String?
  
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
  
  public static func == (lhs: LabelProps, rhs: LabelProps) -> Bool {
    return
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


public struct Label: NodeDescription {
  public typealias NativeView = UILabel

  public var props: LabelProps
  
  public static func applyPropsToNativeView(props: LabelProps,
                                            state: EmptyState,
                                            view: UILabel,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {

    view.frame = props.frame
    view.backgroundColor = props.backgroundColor
    view.layer.cornerRadius = props.cornerRadius.scale(node.plasticMultipler)
    view.layer.borderWidth = props.borderWidth.scale(node.plasticMultipler)
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
  
  public static func render(props: LabelProps,
                            state: EmptyState,
                            update: @escaping (EmptyState)->(),
                            dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
  
  public init(props: LabelProps) {
    self.props = props
  }
}
