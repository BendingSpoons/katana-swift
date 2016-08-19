//
//  NodeDescription.swift
//  Katana
//
//  Created by Luca Querella on 09/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol AnyNodeDescription {
  var children: [AnyNodeDescription] { set get }
  var frame: CGRect { get set }
  var key: String? { get }

  func node() -> AnyNode;
  func node(parentNode: AnyNode?) -> AnyNode
  func replaceKey() -> Int
}

public protocol NodeDescription : AnyNodeDescription {
  associatedtype NativeView: UIView
  associatedtype Props: Equatable, Frameable
  associatedtype State: Equatable
  
  static var viewType : NativeView.Type { get }
  static var initialState: State { get }
  
  
  
  var props: Props { get set }
  
  static func renderView(props: Props,
                         state: State,
                         view: NativeView,
                         update: (State)->()) ->  Void
  
  static func render(props: Props,
                     state: State,
                     children: [AnyNodeDescription],
                     update: (State)->()) -> [AnyNodeDescription]
  
  func replaceKey() -> Int
}

extension NodeDescription {
  public var frame : CGRect {
    get {
      return self.props.frame
    }

    set(newValue) {
      self.props.frame = newValue
    }
  }
  
  public var key: String? {
    guard let p = self.props as? Keyable else {
      return nil
    }
    
    return p.key
  }
}

extension NodeDescription {
  
  public static func renderView(props: Props, state: State, view: NativeView, update: (State)->())  {
    view.frame = props.frame
  }
  
  static func render(props: Props,
                     state: State,
                     children: [AnyNodeDescription],
                     update: (State)->()) -> [AnyNodeDescription] { return [] }
  
  public func node(parentNode: AnyNode?) -> AnyNode {
    return Node(description: self, parentNode: parentNode)
  }
  
  public func node() -> AnyNode {
    return node(parentNode: nil)
  }
  
  public func replaceKey() -> Int {
    return ObjectIdentifier(self.dynamicType).hashValue
  }
}
