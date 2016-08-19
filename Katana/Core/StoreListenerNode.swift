//
//  ProviderNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public class StoreListenerNode<R: Reducer> {
  let store: Store<R>
  let rootNode: AnyNode

  public init(store: Store<R>, rootDescription: AnyNodeDescription) {
    self.store = store
    self.rootNode = rootDescription.node(store: self.store)
    
    let _ = store.addListener({ [unowned self] store in
      self.storeDidChange()
    })
  }

  public func render(container: RenderContainer) {
    self.rootNode.render(container: container)
  }
  
  private func storeDidChange() -> Void {
    self.explore(self.rootNode)
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
