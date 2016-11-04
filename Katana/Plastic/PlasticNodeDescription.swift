//
//  PlasticNodeDescription.swift
//  Katana
//
//  Created by Mauro Bolis on 24/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

// type erasure for PlasticNodeDescription
public protocol AnyPlasticNodeDescription {
  static func anyLayout(views: Any, props: Any, state: Any) -> Void
}

// a node that leverages plastic to layout
public protocol PlasticNodeDescription: AnyPlasticNodeDescription, NodeDescription {
  associatedtype Keys
  
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
  
  public func makeNode(parent: AnyNode) -> AnyNode {
    return PlasticNode(description: self, parent: parent)
  }
  
  func makeRoot(store: AnyStore?) -> Root {
    let root = Root(store: store)
    let node = PlasticNode(description: self, root: root)
    root.node = node
    return root
  }
  
}
