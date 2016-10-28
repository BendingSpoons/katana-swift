//
//  NodeDescriptionWithChildren.swift
//  Katana
//
//  Created by Mauro Bolis on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol AnyNodeDescriptionWithChildren: AnyNodeDescription {
  var children: [AnyNodeDescription] { get set }
}

public protocol NodeDescriptionWithChildren: NodeDescription, AnyNodeDescriptionWithChildren {
  associatedtype PropsType: Childrenable
}

public extension NodeDescriptionWithChildren {
  public var children: [AnyNodeDescription] {
    get {
      return self.props.children
    }
    
    set(newValue) {
      self.props.children = newValue
    }
  }
}
