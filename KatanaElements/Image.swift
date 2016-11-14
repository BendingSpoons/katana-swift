//
//  Image.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit
import Katana

public extension Image {
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
    public var image: UIImage? = nil
    public var tintColor: UIColor = .clear
    
    public init() {}
    
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
        lhs.image == rhs.image &&
        lhs.tintColor == rhs.tintColor
    }
  }
}


public struct Image: NodeDescription {
  public typealias NativeView = UIImageView

  public var props: Props
  
  public static func applyPropsToNativeView(props: Props,
                                            state: EmptyState,
                                            view: UIImageView,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    
    view.frame = props.frame
    view.alpha = props.alpha
    view.backgroundColor = props.backgroundColor
    view.layer.cornerRadius = props.cornerRadius.scale(by: node.plasticMultipler)
    view.layer.borderColor = props.borderColor.cgColor
    view.layer.borderWidth = props.borderWidth.scale(by: node.plasticMultipler)
    view.clipsToBounds = props.clipsToBounds
    view.isUserInteractionEnabled = props.isUserInteractionEnabled
    view.image = props.image
    view.tintColor = props.tintColor
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
