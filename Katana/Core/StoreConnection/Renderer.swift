//
//  ProviderNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/**
 This class has the responsibility to render the nodes tree starting from the description of the root node.
 It will also update the rendering to reflect the changes happening in the `Store`.
 
 ```
 // in the App Delegate
 let store = getStore()
 
 // renderer should be retained, otherwise the all tree will be removed
 // create the renderer starting from the description of the root node and the store
 // (optional, only if you want the UI to be updated reflecting the store changes)
 self.renderer = Renderer(rootDescription: counterScreen, store: store)
 renderer!.render(in: view)
 ```
*/
open class Renderer {
  /// The store that is used in the application
  public let store: AnyStore?
  
  /**
    Reference to the Root's child
   
    - warning node can be sat only once. Trying to update it will result in a runtime exception
  */
  public var rootNode: AnyNode! {
    willSet(rootNode) {
      if self.rootNode != nil {
        fatalError("root node cannot be changed")
      }
    }
  }
  
  /// The unsubscribe store closure
  private var unsubscribe: StoreUnsubscribe?

  /**
   Creates an instance of the Renderer that holds a store
   
   - parameter rootDescription: the root node description
   - parameter store: the store of the application
   - returns: An instance of Renderer that manages rendering and store updates
  */
  public init(rootDescription: AnyNodeDescription, store: AnyStore?) {
    self.store = store
    
    let unsubscribe = self.store?.addListener({ [unowned self] in
      self.storeDidChange()
      })
    
    self.unsubscribe = unsubscribe
    self.rootNode = rootDescription.makeNode(renderer: self)
  }

  /**
   Renders the nodes tree in a container
   
   - parameter container: the container that will be used to render the root node
  */
  public func render(in container: DrawableContainer) {
    guard let rootNode = self.rootNode else {
      fatalError("the node should be provided first")
    }
    
    let n = rootNode as! InternalAnyNode
    n.render(in: container)
  }
  
  /**
   Method that is used to manage an update in the store's state
  */
  private func storeDidChange() -> Void {
    if let rootNode = self.rootNode {
      self.explore(rootNode)
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
      node.update(with: node.anyDescription, animation: .none, completion: nil)
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
  /// traverses the nodes hierarchy up to the root node to get the `root.renderer`
  public var renderer: Renderer {
    var node: AnyNode = self
    while node.parent != nil {
      node = node.parent!
    }
    return node.renderer!
  }
}
