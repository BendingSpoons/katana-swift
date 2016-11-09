//
//  AnyNode.swift
//  Katana
//
//  Created by Mauro Bolis on 09/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public typealias NodeUpdateCompletion = () -> Void

/// Type Erasure protocol for the `Node` class.
public protocol AnyNode: class {
  
  /// Type erasure for the `NodeDescription` that the node holds
  var anyDescription: AnyNodeDescription { get }
  
  /// Children nodes of the node
  var children: [AnyNode]! { get }
  
  /// Array of managed children. See `Node` description for more information about managed children
  var managedChildren: [AnyNode] { get }
  
  /// The parent of the node
  var parent: AnyNode? {get}
  
  /**
   The parent of the node. This variable has a value only if
   the parent is the root of the nodes tree
   */
  var root: Root? {get}
  
  /**
   Updates the node with a new description. Invoking this method will cause an update of the piece of the UI managed by the node
   
   - parameter description: the new description to use to describe the UI
   - throws: this method throw an exception if the given description is not compatible with the node
   */
  func update(with description: AnyNodeDescription)
  
  /**
   Updates the node with a new description. Invoking this method will cause an update of the piece of the UI managed by the node
   The transition from the old description to the new one will be animated
   
   - parameter description: the new description to use to describe the UI
   - parameter parentAnimation: the animation to use to transition from the old description to the new one
   - parameter completion: a completion block to invoke when the update is completed
   
   - throws: this method throw an exception if the given description is not compatible with the node
   */
  func update(with description: AnyNodeDescription, animation: AnimationContainer, completion: NodeUpdateCompletion?)
  
  /**
   Adds a managed child to the node. For more information about managed children see the `Node` class
   
   - parameter description: the description that will characterize the node that will be added
   - parameter container:   the container in which the new node will be drawn
   
   - returns: the node that has been created. The node will have the current node as parent
   */
  func addManagedChild(with description: AnyNodeDescription, in container: DrawableContainer) -> AnyNode
  
  /**
   Removes a managed child from the node. For more information about managed children see the `Node` class
   
   - parameter node: the node to remove
   */
  func removeManagedChild(node: AnyNode)
  
  /// Forces the reload of the node regardless the fact that props and state are changed
  func forceReload()
}
