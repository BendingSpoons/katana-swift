//
//  TouchHandler.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit
import Katana

public typealias TouchHandlerClosure = () -> ()

public extension TouchHandler {
  public struct Props: NodeDescriptionProps, Childrenable, Buildable {
    public var frame = CGRect.zero
    public var key: String?
    public var alpha: CGFloat = 1.0
    
    public var children: [AnyNodeDescription] = []
    public var handlers: [TouchHandlerEvent: TouchHandlerClosure]?
    public var hitTestInsets: UIEdgeInsets = .zero
    
    public init() {}
    
    public static func == (lhs: Props, rhs: Props) -> Bool {
      // always re render, we haven't found a decent way to compare handlers so far
      return false
    }
  }
}

public struct TouchHandler: NodeDescription, NodeDescriptionWithChildren {
  public typealias NativeView = NativeTouchHandler
  
  public var props: Props
  
  public static func applyPropsToNativeView(props: Props,
                                            state: EmptyState,
                                            view: NativeTouchHandler,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    view.frame = props.frame
    view.alpha = props.alpha
    view.handlers = props.handlers
    view.hitTestInsets = props.hitTestInsets
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
