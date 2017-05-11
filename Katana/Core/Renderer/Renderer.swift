//
//  Renderer.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

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
  
  /// The state mock provider to use in the application
  let stateMockProvider: StateMockProvider?

  /// Node IDs that have been updated in the current update cycle
  private var currentUpdateCycleUpdatedNodes: Set<Int>
  
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
   - parameter stateMockProvider: an optional `StateMockProvider` that can be used to mock the internal states
   - returns: An instance of Renderer that manages rendering and store updates
  */
  public init(rootDescription: AnyNodeDescription, store: AnyStore?, stateMockProvider: StateMockProvider? = nil) {
    self.store = store
    self.stateMockProvider = stateMockProvider
    self.currentUpdateCycleUpdatedNodes = []

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
  public func render(in container: PlatformNativeView) {
    guard let rootNode = self.rootNode else {
      fatalError("the node should be provided first")
    }

    let n = rootNode as! InternalAnyNode
    n.render(in: container)
  }

  /**
   Method that is used to manage an update in the store's state
  */
  private func storeDidChange() {
    /*
     Since we are currently interested only in cycles that happens when the store
     changes, we reset the set only when the store effectively changes.
     
     We may have update cycles triggered by other things (e.g., change a node description
     state) but 1) renderer most likely won't be the source of the change and 2) we cannot
     optimize them here
    */
    self.currentUpdateCycleUpdatedNodes = []

    if let rootNode = self.rootNode {
      self.explore(rootNode)
    }
  }
  
  func setNodeAsUpdatedInCurrentRenderCycle(_ node: AnyNode) {
    let id = ObjectIdentifier(node).hashValue
    self.currentUpdateCycleUpdatedNodes.insert(id)
  }

  /**
   Method that explores a node (and recursively the children) and triggers an UI
   update if necessary. 
   
   - parameter node: the node to explore
  */
  private func explore(_ node: AnyNode) {
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
      .filter { !self.currentUpdateCycleUpdatedNodes.contains(ObjectIdentifier($0).hashValue) }
      .forEach { explore($0) }

    node.managedChildren.forEach { explore($0) }
  }

  /// When the root is deallocated, we should unsubscribe it from the store changes
  deinit {
    self.unsubscribe?()
  }
}
