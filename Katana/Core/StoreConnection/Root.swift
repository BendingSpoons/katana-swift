//
//  ProviderNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public class Root {
  
  public let store: AnyStore?
  
  public var node: AnyNode? {
    willSet(node) {
      if (self.node != nil) {
        fatalError("node cannot be changed")
      }
    }
  }
  
  public var unsubscribe: StoreUnsubscribe?

  public init(store: AnyStore?) {
    self.store = store
    
    let unsubscribe = store?.addListener({ [unowned self] in
      self.storeDidChange()
    })
    
    self.unsubscribe = unsubscribe
  }

  
  public func draw(container: DrawableContainer) {
    guard let node = self.node else {
      fatalError("the node should be provided firt")
    }
    
    let n = node as! InternalAnyNode
    n.draw(container: container)
  }
  
  private func storeDidChange() -> Void {
    if let node = self.node {
      self.explore(node)
    }
  }
  
  private func explore(_ node: AnyNode) -> Void {
    guard let children = node.children else {
      fatalError("Impossibile to retrieve children")
    }

    var childrenTable = [Int: AnyNode]()
    
    for node in children {
      childrenTable[ObjectIdentifier(node).hashValue] = node
    }
    
    if node.anyDescription is AnyConnectedNodeDescription {
      // ok the description is connected to the node, let's trigger an update
      try! node.update(description: node.anyDescription)
    }
    
    node.children?
      .filter {
        childrenTable[ObjectIdentifier($0).hashValue] != nil
      }
      .forEach {
        explore($0)
      }
  }
  
  deinit {
    self.unsubscribe?()
  }
}


public extension Node {
  var treeRoot : Root {
    var node: AnyNode = self
    while (node.parent != nil) {
      node = node.parent!
    }
    return node.root!
  }
}


