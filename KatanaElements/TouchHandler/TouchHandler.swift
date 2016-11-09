//
//  TouchHandler.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit
import Katana

public typealias TouchHandlerClosure = () -> Void

public struct TouchHandlerProps: NodeDescriptionProps, Childrenable, Keyable, Buildable {
  public var frame = CGRect.zero
  public var children: [AnyNodeDescription] = []
  public var key: String?
  public var handlers: [TouchHandlerEvent: TouchHandlerClosure]?
  public var hitTestInsets: UIEdgeInsets = .zero
  
  public init() {}
  
  public static func == (lhs: TouchHandlerProps, rhs: TouchHandlerProps) -> Bool {
    // always re render, we haven't found a decent way to compare handlers so far
    return false
  }
}

public struct TouchHandler: NodeDescription, NodeDescriptionWithChildren {
  public typealias NativeView = NativeTouchHandler
  
  public var props: TouchHandlerProps
  
  public static func applyPropsToNativeView(props: TouchHandlerProps,
                                            state: EmptyState,
                                            view: NativeTouchHandler,
                                            update: @escaping (EmptyState)->(),
                                            node: AnyNode) {
    view.frame = props.frame
    view.handlers = props.handlers
    view.hitTestInsets = props.hitTestInsets
  }

  public static func childrenDescriptions(props: TouchHandlerProps,
                                          state: EmptyState,
                                          update: @escaping (EmptyState)->(),
                                          dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
    
    return props.children
  }
  
  public init(props: TouchHandlerProps) {
    self.props = props
  }
  
  public init(props: TouchHandlerProps, _ children: () -> [AnyNodeDescription]) {
    self.props = props
    self.props.children = children()
  }
}
