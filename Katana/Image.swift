//
//  Image.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public struct ImageProps: NodeProps, Keyable, Buildable {
  public var frame = CGRect.zero
  public var key: String?
  
  public var backgroundColor = UIColor.white
  public var cornerRadius: CGFloat = 0.0
  public var borderWidth: CGFloat = 0.0
  public var borderColor = UIColor.clear
  public var clipsToBounds = true
  public var isUserInteractionEnabled = false
  public var image: UIImage? = nil
  public var tintColor: UIColor = .clear
  
  public init() {}
  
  public static func == (lhs: ImageProps, rhs: ImageProps) -> Bool {
    return
      lhs.frame == rhs.frame &&
        lhs.key == rhs.key &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.cornerRadius == rhs.cornerRadius &&
        lhs.borderWidth == rhs.borderWidth &&
        lhs.borderColor == rhs.borderColor &&
        lhs.clipsToBounds == rhs.clipsToBounds &&
        lhs.isUserInteractionEnabled == rhs.isUserInteractionEnabled &&
        lhs.image == rhs.image &&
        lhs.tintColor == rhs.tintColor
  }
}


public struct Image: NodeDescription {
  public typealias NativeView = UIImageView

  public var props: ImageProps
  
  public static func applyPropsToNativeView(props: ImageProps,
                                            state: EmptyState,
                                            view: UIImageView,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    
    view.frame = props.frame
    view.backgroundColor = props.backgroundColor
    view.layer.cornerRadius = props.cornerRadius
    view.layer.borderColor = props.borderColor.cgColor
    view.layer.borderWidth = props.borderWidth
    view.clipsToBounds = props.clipsToBounds
    view.isUserInteractionEnabled = props.isUserInteractionEnabled
    view.image = props.image
    view.tintColor = props.tintColor
  }
  
  public static func render(props: ImageProps,
                            state: EmptyState,
                            update: @escaping (EmptyState)->(),
                            dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
  
  public init(props: ImageProps) {
    self.props = props
  }
}
