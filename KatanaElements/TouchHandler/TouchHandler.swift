//
//  TouchHandler.swift
//  Katana
//
//  Created by Mauro Bolis on 14/10/2016.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import UIKit
import Katana

public typealias TouchHandlerClosure = () -> Void

public struct TouchHandlerProps: NodeProps, Childrenable, Keyable, Buildable {
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
