//
//  NodeDescriptionWithChildren.swift
//  Katana
//
//  Created by Mauro Bolis on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/// Type Erasure for `NodeDescriptionWithChildren`
public protocol AnyNodeDescriptionWithChildren: AnyNodeDescription {
  /// children of the description
  var children: [AnyNodeDescription] { get set }
}

/**
 This is the protocol that descriptions (that is, concrete implementations of `NodeDescription`) need to
 implement if they contain children. For example the `View` component of `KatanaElements` implements this
 protocol and it allows to implement the following behaviour:
 
 ```
 func childrenDescriptions(...) {
  View(props: ViewProps()) {
    return [
      Image(props: ImageProps()),
      Button(props: ButtonProps()),
    ]
  }
 }
 ```
 Basically we can return a View description that holds some children.
 
 Katana will internally leverage this protocol to correctly handle the children (e.g., render and apply the layout).
*/
public protocol NodeDescriptionWithChildren: NodeDescription, AnyNodeDescriptionWithChildren {
  /// Props should implement `Childrenable`
  associatedtype PropsType: Childrenable
}

public extension NodeDescriptionWithChildren {
  /// the default implementation is a proxy for `props.children`
  public var children: [AnyNodeDescription] {
    get {
      return self.props.children
    }
    
    set(newValue) {
      self.props.children = newValue
    }
  }
}

/// This protocol is used for properties of descriptions that implement the `NodeDescriptionWithChildren` protocol
public protocol Childrenable {
  /// The children of the description
  var children: [AnyNodeDescription] { get set }
}
