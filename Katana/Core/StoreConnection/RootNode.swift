//
//  ProviderNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public class RootNode {
  public let store: AnyStore
  public let node: AnyNode

  public init(store: AnyStore, node: AnyNode) {
    self.store = store
    self.node = node
    
    let _ = store.addListener({ [unowned self] in
      self.storeDidChange()
    })
  }

  public func draw(container: DrawableContainer) {
    self.node.draw(container: container)
  }
  
  private func storeDidChange() -> Void {
    self.explore(self.node)
  }
  
  private func explore(_ node: AnyNode) -> Void {
    guard let children = node.children else {
      fatalError("Impossibile to retrieve children")
    }

    var childrenTable = [Int: AnyNode]()
    
    for node in children {
      childrenTable[ObjectIdentifier(node).hashValue] = node
    }
    
    if let n = node as? ConnectedNode {
      n.storeDidChange()
    }
    
    node.children?
      .filter {
        childrenTable[ObjectIdentifier($0).hashValue] != nil
      }
      .forEach {
        explore($0)
      }
  }
}

public extension AnyNodeDescription {
  public func rootNode(store: AnyStore) -> RootNode {
    return RootNode(store: store, node:self.node())
  }
}
