//
//  NodeDescription.swift
//  Katana
//
//  Created by Luca Querella on 09/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

let NO_REFERENCE_SIZE = CGSize(width: -999, height: -999)

public protocol AnyNodeDescription {
  var children: [AnyNodeDescription] { set get }
  var frame: CGRect { get set }
  var key: String? { get }

  func node() -> AnyNode;
  func node(parentNode: AnyNode?) -> AnyNode
  func replaceKey() -> Int
  func referenceSize() -> CGSize
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
  
  
  static func layout(views: PlasticViewsContainer,
                     props: Props,
                     state: State) -> Void
  
  
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
  
  
  // default implementation added to support the migration from frame based to
  // plastic based, remove at the end
  public static func layout(views: PlasticViewsContainer,
                     props: Props,
                     state: State) -> Void {
    
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
  
  public func referenceSize() -> CGSize {
    return NO_REFERENCE_SIZE
  }
}
