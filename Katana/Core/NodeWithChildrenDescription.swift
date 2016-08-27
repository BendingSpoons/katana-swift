//
//  NodeDescriptionWithChildren.swift
//  Katana
//
//  Created by Mauro Bolis on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyNodeWithChildrenDescription: AnyNodeDescription {
  var children: [AnyNodeDescription] { get set }
}

public protocol NodeWithChildrenDescription: NodeDescription, AnyNodeWithChildrenDescription {
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
