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
  public static func < (lhs: Self, rhs: Self) -> Bool {
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
  
  static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType) -> Void
  static func layoutHash(props: PropsType, state: StateType) -> Int?
}

public extension PlasticNodeDescription {
  static func anyLayout(views: Any, props: Any, state: Any) -> Void {
    if let p = props as? PropsType, let s = state as? StateType, let v = views as? ViewsContainer<Keys> {
      layout(views: v, props: p, state: s)
    }
  }
  
  static func layoutHash(props: PropsType, state: StateType) -> Int? {
    return nil
  }
  
  public func node(parent: AnyNode?) -> AnyNode {
    return PlasticNode(description: self, parent: parent, root: nil)
  }
  
  func root(store: AnyStore?) -> Root {
    let root = Root(store: store)
    let node = PlasticNode(description: self, parent: nil, root: root)
    root.node = node
    return root
  }
  
}
