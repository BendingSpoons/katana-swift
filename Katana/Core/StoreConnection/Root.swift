//
//  ProviderNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/**
 This class represents the root node of the nodes tree.
 
 It should be created using the `makeRoot` method of `NodeDescription`.
 A typical usage of the `Root` is the following:
 
 ```
 // in the App Delegate
 let store = getStore()
 
 // root should be retained, otherwise the all tree will be removed
 // get the root and draw it
 self.root = Description(props: props).makeRoot(store: store)
 self.root!.draw(in: view)
 ```
*/
open class Root {
  /// The store that is used in the application
  public let store: AnyStore?
  
  /**
    Reference to the Root's child
   
    - warning node can be sat only once. Trying to update it will result in a runtime exception
  */
  public var node: AnyNode? {
    willSet(node) {
      if self.node != nil {
        fatalError("node cannot be changed")
      }
    }
  }
  
  /// The unsubscribe store closure
  public var unsubscribe: StoreUnsubscribe?

  /**
   Creates an instance of root that holds a store
   
   - parameter store: the store of the application
   - returns: An instance of Root that manages the store
  */
  public init(store: AnyStore?) {
    self.store = store
    
    let unsubscribe = store?.addListener({ [unowned self] in
      self.storeDidChange()
    })
    
    self.unsubscribe = unsubscribe
  }

  /**
   Draws the root in a container
   
   - parameter container: the container that will be used to draw the root node
   
   - warning: It is possible to invoke this method only after `node` has been setted.
  */
  public func draw(in container: DrawableContainer) {
    guard let node = self.node else {
      fatalError("the node should be provided firt")
    }
    
    let n = node as! InternalAnyNode
    n.draw(in: container)
  }
  
  /**
   Method that is used to manage an update in the store's state
  */
  private func storeDidChange() -> Void {
    if let node = self.node {
      self.explore(node)
    }
  }
  
  /**
   Method that explores a node (and recursively the children) and triggers an UI
   update if necessary. 
   
   - parameter node: the node to explore
  */
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
  
  /// When the root is deallocated, we should unsubscribe it from the store changes
  deinit {
    self.unsubscribe?()
  }
}


public extension AnyNode {
  /// Returns the Root of the nodes tree
  public var treeRoot: Root {
    var node: AnyNode = self
    while node.parent != nil {
      node = node.parent!
    }
    return node.root!
  }
}
