//
//  Image.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public struct ImageProps: NodeDescriptionProps {
  public var frame = CGRect.zero
  public var key: String?
  public var alpha: CGFloat = 1.0
  
  public var backgroundColor = UIColor.white
  public var image: UIImage? = nil
  
  public init() {}
  
  public static func == (lhs: ImageProps, rhs: ImageProps) -> Bool {
    return
      lhs.frame == rhs.frame &&
      lhs.key == rhs.key &&
      lhs.alpha == rhs.alpha &&
      lhs.backgroundColor == rhs.backgroundColor &&
      lhs.image == rhs.image
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
    view.image = props.image
  }
  
  public static func childrenDescriptions(props: ImageProps,
                                          state: EmptyState,
                                          update: @escaping (EmptyState)->(),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
  
  public init(props: ImageProps) {
    self.props = props
  }
}
