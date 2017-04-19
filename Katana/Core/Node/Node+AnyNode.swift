//
//  Node+AnyNode.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

extension Node: AnyNode {
  /**
   Implementation of the AnyNode protocol.
   
   - seeAlso: `AnyNode`
   */
  public var anyDescription: AnyNodeDescription {
    return self.description
  }

  /**
   Implementation of the AnyNode protocol.
   
   - seeAlso: `AnyNode`
   */
  public func update(with description: AnyNodeDescription) {
    self.update(with: description, animation: .none, completion: nil)
  }

  /**
   Implementation of the AnyNode protocol.
   
   - seeAlso: `AnyNode`
   */
  public func update(with description: AnyNodeDescription, animation: AnimationContainer, completion: NodeUpdateCompletion?) {
    guard var description = description as? Description else {
      fatalError("Impossible to use the provided description to update the node")
    }

    description.props = Node.updatedPropsWithConnect(
      description: description,
      props: description.props,
      store: self.renderer?.store
    )

    self.update(for: self.state, description: description, animation: animation, completion: completion)
  }

  /**
   Implementation of the AnyNode protocol.
   
   - seeAlso: `AnyNode`
   */
  public func forceReload() {
    self.update(for: self.state, description: self.description, animation: .none, force: true)
  }
}
