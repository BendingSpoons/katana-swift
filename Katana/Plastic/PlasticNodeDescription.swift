//
//  PlasticNodeDescription.swift
//  Katana
//
//  Created by Mauro Bolis on 24/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public protocol NodeDescriptionKeys: RawRepresentable, Hashable, Comparable {
  init?(rawValue: String)
}

public extension NodeDescriptionKeys where RawValue: Comparable {
  public static func <(lhs: Self, rhs: Self) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

// type erasure for PlasticNodeDescription
public protocol AnyPlasticNodeDescription {
  static func anyLayout(views: Any, props: Any, state: Any) -> Void
}

// a node that leverages plastic to layout
public protocol PlasticNodeDescription: AnyPlasticNodeDescription, NodeDescription {
  associatedtype Keys: NodeDescriptionKeys
  static func layout(views: ViewsContainer<Keys>, props: Props, state: State) -> Void
}

public extension PlasticNodeDescription {
  static func anyLayout(views: Any, props: Any, state: Any) -> Void {
    if let p = props as? Props, let s = state as? State, let v = views as? ViewsContainer<Keys> {
      layout(views: v, props: p, state: s)
    }
  }
  
  public func node(store: AnyStore) -> RootNode {
    return RootNode(store: store, node: PlasticNode(description: self, parentNode: nil, store: store))
  }
  
  public func node(parentNode: AnyNode) -> AnyNode {
    return PlasticNode(description: self, parentNode: parentNode, store: parentNode.store)
  }
}
