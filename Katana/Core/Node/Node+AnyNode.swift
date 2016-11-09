//
//  Node+AnyNode.swift
//  Katana
//
//  Created by Mauro Bolis on 09/11/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

extension Node: AnyNode {
  /**
   Implementation of the AnyNode protocol.
   
   - seeAlso: `AnyNode`
   */
  public var anyDescription: AnyNodeDescription {
    get {
      return self.description
    }
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
    
    description.props = self.updatedPropsWithConnect(description: description, props: description.props)
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
