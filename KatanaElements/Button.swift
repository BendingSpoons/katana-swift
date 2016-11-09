//
//  Button.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit
import Katana

public struct ButtonProps: NodeDescriptionProps, Keyable, Buildable {
  public var frame = CGRect.zero
  public var key: String?
  
  public var backgroundColor = UIColor.white
  public var cornerRadius: Value = .zero
  public var borderWidth: Value = .zero
  public var borderColor = UIColor.clear
  public var clipsToBounds = true
  public var isEnabled = true
  public var contentEdgeInsets: EdgeInsets = .zero
  public var titleEdgeInsets: EdgeInsets = .zero
  public var imageEdgeInsets: EdgeInsets = .zero
  public var adjustsImageWhenHighlighted = true
  public var adjustsImageWhenDisabled = true
  public var showsTouchWhenHighlighted = false
  public var titles: [UIControlState: String] = [:]
  public var titleColors: [UIControlState: UIColor] = [:]
  public var titleShadowColors: [UIControlState: UIColor] = [:]
  public var images: [UIControlState: UIImage] = [:]
  public var backgroundImages: [UIControlState: UIImage] = [:]
  public var attributedTitles: [UIControlState: NSAttributedString] = [:]
  public var touchHandlers: [TouchHandlerEvent: TouchHandlerClosure] = [:]
  
  public init() {}
  
  public static func == (lhs: ButtonProps, rhs: ButtonProps) -> Bool {
    return
      lhs.key == rhs.key &&
      lhs.frame == rhs.frame &&
      lhs.backgroundColor == rhs.backgroundColor &&
      lhs.cornerRadius == rhs.cornerRadius &&
      lhs.borderWidth == rhs.borderWidth &&
      lhs.borderColor == rhs.borderColor &&
      lhs.clipsToBounds == rhs.clipsToBounds &&
      lhs.isEnabled == rhs.isEnabled &&
      lhs.contentEdgeInsets == rhs.contentEdgeInsets &&
      lhs.titleEdgeInsets == rhs.titleEdgeInsets &&
      lhs.imageEdgeInsets == rhs.imageEdgeInsets &&
      lhs.adjustsImageWhenHighlighted == rhs.adjustsImageWhenHighlighted &&
      lhs.adjustsImageWhenDisabled == rhs.adjustsImageWhenDisabled &&
      lhs.showsTouchWhenHighlighted == rhs.showsTouchWhenHighlighted &&
      lhs.titles == rhs.titles &&
      lhs.titleColors == rhs.titleColors &&
      lhs.titleShadowColors == rhs.titleShadowColors &&
      lhs.images == rhs.images &&
      lhs.backgroundImages == rhs.backgroundImages &&
      lhs.attributedTitles == rhs.attributedTitles
  }
}


public struct Button: NodeDescription {
  public typealias NativeView = NativeButton
  
  public var props: ButtonProps
  
  public static func applyPropsToNativeView(props: ButtonProps,
                                            state: EmptyState,
                                            view: NativeButton,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    
    view.frame = props.frame
    view.backgroundColor = props.backgroundColor
    view.layer.cornerRadius = props.cornerRadius.scale(by: node.plasticMultipler)
    view.layer.borderWidth = props.borderWidth.scale(by: node.plasticMultipler)
    view.layer.borderColor = props.borderColor.cgColor
    view.clipsToBounds = props.clipsToBounds
    view.isEnabled = props.isEnabled
    view.contentEdgeInsets = props.contentEdgeInsets.scale(by: node.plasticMultipler)
    view.titleEdgeInsets = props.contentEdgeInsets.scale(by: node.plasticMultipler)
    view.imageEdgeInsets = props.imageEdgeInsets.scale(by: node.plasticMultipler)
    view.imageEdgeInsets = props.imageEdgeInsets.scale(by: node.plasticMultipler)
    view.adjustsImageWhenHighlighted = props.adjustsImageWhenHighlighted
    view.adjustsImageWhenDisabled = props.adjustsImageWhenDisabled
    view.showsTouchWhenHighlighted = props.showsTouchWhenHighlighted
    
    
    // reset UIButton state
    for state in UIControlState.allValues {
      view.setTitle(nil, for: state)
      view.setTitleColor(nil, for: state)
      view.setTitleShadowColor(nil, for: state)
      view.setImage(nil, for: state)
      view.setBackgroundImage(nil, for: state)
      view.setAttributedTitle(nil, for: state)
    }
    
    // set items from props
    for (state, title) in props.titles {
      view.setTitle(title, for: state)
    }
    
    for (state, color) in props.titleColors {
      view.setTitleColor(color, for: state)
    }
    
    for (state, color) in props.titleShadowColors {
      view.setTitleShadowColor(color, for: state)
    }
    
    for (state, image) in props.images {
      view.setImage(image, for: state)
    }
    
    for (state, image) in props.backgroundImages {
      view.setBackgroundImage(image, for: state)
    }
    
    for (state, title) in props.attributedTitles {
      view.setAttributedTitle(title, for: state)
    }
    
    view.touchHandlers = props.touchHandlers
    
  }
  
  public static func childrenDescriptions(props: ButtonProps,
                                          state: EmptyState,
                                          update: @escaping (EmptyState)->(),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    return []
  }
  
  public init(props: ButtonProps) {
    self.props = props
  }
}

extension UIControlState: Hashable {
  public var hashValue: Int {
    return self.rawValue.hashValue
  }
}

fileprivate extension UIControlState {
  fileprivate static var allValues: [UIControlState] {
    if #available(iOS 9.0, *) {
      return [.normal, .highlighted, .disabled, .selected, .application, .reserved, .focused]
    
    } else {
      return [.normal, .highlighted, .disabled, .selected, .application, .reserved]
    }
  }
}
