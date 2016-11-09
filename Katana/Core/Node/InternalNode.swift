//
//  InternalNode.swift
//  Katana
//
//  Created by Mauro Bolis on 09/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/**
 Internal protocol that allow the drawing of the node in a container.
 
 We basically don't want to expose `draw` as a public method. We want to force developers
 to call draw only on the renderer by invoking
 
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
