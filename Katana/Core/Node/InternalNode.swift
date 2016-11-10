//
//  InternalNode.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 Internal protocol that allow the drawing of the node in a container.
 
 We basically don't want to expose `draw` as a public method. We want to force developers
 to call render only on the renderer by invoking
 
 ```
 renderer = Renderer(rootDescription: rootNodeDescription, store: store)
 renderer.render(in: view)
 ```
 */
protocol InternalAnyNode: AnyNode {
  /**
   Renders the node in the given container
   - parameter container: the container to use to draw the node
   */
  func render(in container: DrawableContainer)
}
