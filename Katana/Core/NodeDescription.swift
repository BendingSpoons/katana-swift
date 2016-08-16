//
//  NodeDescription.swift
//  Katana
//
//  Created by Luca Querella on 09/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol AnyNodeDescription {
  func node() -> AnyNode;
  func replaceKey() -> Int
  
}

public protocol NodeDescription : AnyNodeDescription {
  associatedtype NativeView: UIView
  associatedtype Props: Equatable,Frameable
  associatedtype State: Equatable
  
  static var viewType : NativeView.Type { get }
  static var initialState: State { get }
  
  var children: [AnyNodeDescription] { set get }
  
  var props: Props { get }
  
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
  
  public static func renderView(props: Props, state: State, view: NativeView, update: (State)->())  {
    view.frame = props.frame
  }
  
  static func render(props: Props,
                     state: State,
                     children: [AnyNodeDescription],
                     update: (State)->()) -> [AnyNodeDescription] { return [] }
  
  
  public func node() -> AnyNode {
    return Node(description: self)
  }
  
  public func replaceKey() -> Int {
    return ObjectIdentifier(self.dynamicType).hashValue
  }
  
}
