//
//  NodeDescription.swift
//  Katana
//
//  Created by Luca Querella on 09/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol NodeState: Equatable {
  init()
}

public extension NodeState {
  static func == (l: Self, r: Self) -> Bool {
    return false
  }
}

public protocol NodeProps: Equatable, Frameable {}

public extension NodeProps {
  static func == (l: Self, r: Self) -> Bool {
    return false
  }
}

public protocol AnyNodeDescription {
  var frame: CGRect { get set }
  var key: String? { get }
  var anyProps: Any { get }
  var replaceKey: Int { get }
  
  func makeNode(parent: AnyNode?) -> AnyNode
  func makeRoot(store: AnyStore?) -> Root
}

public protocol NodeDescription: AnyNodeDescription {
  associatedtype NativeView: UIView = UIView
  associatedtype PropsType: NodeProps = EmptyProps
  associatedtype StateType: NodeState = EmptyState
  
  var props: PropsType { get set }
  
  static func applyPropsToNativeView(props: PropsType,
                                     state: StateType,
                                     view: NativeView,
                                     update: @escaping (StateType)->(),
                                     node: AnyNode) -> Void
  
  static func childrenDescriptions(props: PropsType,
                     state: StateType,
                     update: @escaping (StateType)->(),
                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription]
  
  static func childrenAnimation(currentProps: PropsType,
                                             nextProps: PropsType,
                                             currentState: StateType,
                                             nextState: StateType,
                                             parentAnimation: Animation) -> Animation
  
}

extension NodeDescription {
  
  public static func applyPropsToNativeView(props: PropsType,
                                            state: StateType,
                                            view: NativeView,
                                            update: @escaping (StateType)->(),
                                            node: AnyNode) -> Void {
    view.frame = props.frame
  }
  
  public static func childrenAnimation(currentProps: PropsType,
                                                    nextProps: PropsType,
                                                    currentState: StateType,
                                                    nextState: StateType,
                                                    parentAnimation: Animation) -> Animation {
    return parentAnimation
  }
}

extension AnyNodeDescription where Self: NodeDescription {
  
  public var frame: CGRect {
    get {
      return self.props.frame
    }
    
    set(newFrame) {
      self.props.frame = newFrame
    }
  }
  
  public var key: String? {
    guard let props = self.props as? Keyable else {
      return nil
    }
    
    return props.key
  }
  
  public var anyProps: Any {
    return self.props
  }
  
  public func makeNode(parent: AnyNode?) -> AnyNode {
    return Node(description: self, parent: parent)
  }
  
  public func makeRoot(store: AnyStore?) -> Root {
    let root = Root(store: store)
    let node = Node(description: self, parent: nil, root: root)
    root.node = node
    return root
  }
  
  public var replaceKey: Int {
    
    if let props = self.props as? Keyable, let key = props.key {
      return "\(ObjectIdentifier(type(of: self)).hashValue)_\(key)".hashValue
    }
    
    return ObjectIdentifier(type(of: self)).hashValue
  }
}
