//
//  View.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public struct TextProps: NodeProps, Colorable, Textable, TouchDisableable, Keyable, Bordable {
  public var frame = CGRect.zero
  public var color = UIColor.white
  public var touchDisabled =  true
  public var text: NSAttributedString = NSAttributedString()
  public var key: String?
  public var borderColor = UIColor.black
  public var borderWidth = CGFloat(0)
  
  public static func == (lhs: TextProps, rhs: TextProps) -> Bool {
    return lhs.frame == rhs.frame &&
      lhs.color == rhs.color &&
      lhs.touchDisabled == rhs.touchDisabled &&
      lhs.text == rhs.text
  }
  
  public init() {}
}


public struct Text: NodeDescription {
  public typealias NativeView = UILabel

  public var props: TextProps
  
  public static func applyPropsToNativeView(props: TextProps,
                                            state: EmptyState,
                                            view: UILabel,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    view.frame = props.frame
    view.backgroundColor = props.color
    view.isUserInteractionEnabled = !props.touchDisabled
    view.attributedText = props.text
    view.layer.borderWidth = props.borderWidth
    view.layer.borderColor = props.borderColor.cgColor
  }
  
  public static func childrenDescriptions(props: TextProps,
                            state: EmptyState,
                            update: @escaping (EmptyState)->(),
                            dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
  
  public init(props: TextProps) {
    self.props = props
  }
}
