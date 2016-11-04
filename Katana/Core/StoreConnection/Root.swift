//
//  ProviderNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

open class Root {
  public let store: AnyStore?
  
  public var node: AnyNode? {
    willSet(node) {
      if self.node != nil {
        fatalError("node cannot be changed")
      }
    }
  }
  
  private var unsubscribe: StoreUnsubscribe?

  public init(store: AnyStore?) {
    self.store = store
    
    let unsubscribe = store?.addListener({ [unowned self] in
      self.storeDidChange()
    })
    
    self.unsubscribe = unsubscribe
  }

  
  public func render(in container: DrawableContainer) {
    guard let node = self.node else {
      fatalError("the node should be provided firt")
    }
    
    let n = node as! InternalAnyNode
    n.render(in: container)
  }
  
  private func storeDidChange() -> Void {
    if let node = self.node {
      self.explore(node)
    }
  }
  
  private func explore(_ node: AnyNode) -> Void {
    var childrenTable = [Int: AnyNode]()
    
    for node in node.children {
      childrenTable[ObjectIdentifier(node).hashValue] = node
    }
    
    if node.anyDescription is AnyConnectedNodeDescription {
      // ok the description is connected to the node, let's trigger an update
      try! node.update(with: node.anyDescription)
    }
    
    node.children
      .filter { childrenTable[ObjectIdentifier($0).hashValue] != nil }
      .forEach { explore($0) }
    
    node.managedChildren.forEach { explore($0) }
  }
  
  deinit {
    self.unsubscribe?()
  }
}


public extension AnyNode {
  public var treeRoot: Root {
    var node: AnyNode = self
    while node.parent != nil {
      node = node.parent!
    }
    return node.root!
  }
}
