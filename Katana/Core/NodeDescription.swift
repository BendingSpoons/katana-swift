//
//  NodeDescription.swift
//  Katana
//
//  Created by Luca Querella on 09/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol AnyNodeDescription {
  var frame: CGRect { get set }
  var key: String? { get }
  
  func node(store: AnyStore) -> AnyNode
  func node(parentNode: AnyNode?, store: AnyStore) -> AnyNode
  func replaceKey() -> Int
}

public protocol NodeDescription : AnyNodeDescription {
  associatedtype NativeView: UIView
  associatedtype Props: Equatable, Frameable
  associatedtype State: Equatable
  
  static var nativeViewType : NativeView.Type { get }
  static var initialState: State { get }
  
  var props: Props { get set }
  
  static func applyPropsToNativeView(props: Props,
                         state: State,
                         view: NativeView,
                         update: (State)->()) ->  Void
  
  static func render(props: Props,
                     state: State,
                     update: (State)->(),
                     dispatch: StoreDispatch) -> [AnyNodeDescription]
  
  func replaceKey() -> Int
}

extension NodeDescription {
  
  public var frame : CGRect {
    
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
}

extension NodeDescription {
  public static func applyPropsToNativeView(props: Props, state: State, view: NativeView, update: (State)->())  {
    view.frame = props.frame
  }

  
  public func node(store: AnyStore) -> AnyNode {
    return node(parentNode: nil, store: store)
  }
  
  public func node(parentNode: AnyNode?, store: AnyStore) -> AnyNode {
    return Node(description: self, parentNode: parentNode, store: store)
  }
  
  public func replaceKey() -> Int {
    return ObjectIdentifier(self.dynamicType).hashValue
  }
}

public protocol AnyNodeWithChildrenDescription {
  var children: [AnyNodeDescription] { get set }
}

public protocol NodeWithChildrenDescription: AnyNodeWithChildrenDescription {
  associatedtype Props: Childrenable
  var props: Props { get set }
}

public extension NodeWithChildrenDescription {
  public var children: [AnyNodeDescription] {
    get {
      return self.props.children
    }
    
    set(newValue) {
      self.props.children = newValue
    }
  }
}
