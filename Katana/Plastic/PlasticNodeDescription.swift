//
//  PlasticNodeDescription.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/// Type Erasure for `PlasticNodeDescription`
public protocol AnyPlasticNodeDescription {
  /**
   Implements the layout logic of the node description
   
   - seeAlso: `PlasticNodeDescription`, `layout(views:props:state:)` method
   */
  static func anyLayout(views: Any, props: Any, state: Any)
}

/**
 This protocol allows a `NodeDescription` to use the Plastic layout system.
*/
public protocol PlasticNodeDescription: AnyPlasticNodeDescription, NodeDescription {
  /**
   Node descriptions should implement this method and provide the proper layout logic.
   
   This method receives as input, beside the props and the state of the node description,
   a `ViewsContainer` that basically holds a placeholder for each node description with a key
   returned in the `childrenDescriptions` method. You can access these placeholders by using the
   same key.
   
   The following is an example of implementation:
   
   ```
   // in the childrenDescriptions method
   return [
    View(props: ViewProps(key: Keys.view))
   ]
   
   // in the layout method
   // we make view with key `.view` as big as the native view
   views[.view]?.fill(views.nativeView)
   ```
   
   - parameter views: the container that holds the node description children
   - parameter props: the current props of the node description
   - parameter state: the current state of the node description
  */
  static func layout(views: ViewsContainer<Keys>, props: PropsType, state: StateType)
  
  /**
   The layout logic may be expensive in some cases. By implementing this method, you can actually
   cache the result of the layout.
   
   The idea is that, given a certain instance of props and state, you should return an hash value.
   The calculated hash value will be used to store and retrieve the result of the layout logic.
   This means that if you return an hash value that has been stored before, the `layout(views:props:state:)`
   method won't be invoked and the cached result will be used instead.
   
   Ideally you should somehow combine all the values (taken from both the props and the state) that influence
   the result of your layout logic. In the case where the layout is always the same (that is, frames never change),
   then you can return a constant value.
   
   The caching system is disabled by default. You can activate it for a specific implementation of `PlasticNodeDescription`
   by implementing this method.
   
   - parameter props: the props that will be used in the layout
   - parameter state: the state that will be used in the layout
   - returns: an hash value with the properties described in the description of the method
  */
  static func layoutHash(props: PropsType, state: StateType) -> Int?
}

public extension PlasticNodeDescription {
  /**
   Implementation of the `AnyPlasticNodeDescription` protocol.
   
   - seeAlso: `AnyPlasticNodeDescription`
  */
  static func anyLayout(views: Any, props: Any, state: Any) {
    if let p = props as? PropsType, let s = state as? StateType, let v = views as? ViewsContainer<Keys> {
      layout(views: v, props: p, state: s)
    }
  }
  
  /// default value is `nil`
  static func layoutHash(props: PropsType, state: StateType) -> Int? {
    return nil
  }
  
  /**
   Creates an instance of `Node` given the parent `Node`.
   
   This method is the same as the `NodeDescription` `makeNode(parent:)` but it
   returns an instance of `PlasticNode`
  */
  public func makeNode(parent: AnyNode) -> AnyNode {
    return PlasticNode(description: self, parent: parent)
  }
  
  /**
   Creates an instance of `Node` given the `Renderer` responsible to render the Nodes tree
   starting from this Plastic Node Description.
   
   This method is the same as the `NodeDescription` `makeNode(renderer:)` but it
   returns an instance of `PlasticNode`
   */
  public func makeNode(renderer: Renderer) -> AnyNode {
    return PlasticNode(description: self, renderer: renderer)
  }
  
}
