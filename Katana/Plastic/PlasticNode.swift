//
//  PlasticNode.swift
//  Katana
//
//  Created by Mauro Bolis on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public class PlasticNode<Description: PlasticNodeDescription>: Node<Description> {
  override public func processedChildrenBeforeDraw(_ children: [AnyNodeDescription]) -> [AnyNodeDescription] {
    let newChildren = super.processedChildrenBeforeDraw(children)
    return self.applyLayout(to: newChildren, description: self.description)
  }
  
  func applyLayout(to children: [AnyNodeDescription], description: Description) -> [AnyNodeDescription] {
    let multiplier = self.plasticMultipler
    let frame = self.description.props.frame
    let container = ViewsContainer<Description.Keys>(nativeViewFrame: frame, children: children, multiplier: multiplier)
    let selfType = type(of: description)
    let layoutHash = selfType.layoutHash(props: self.description.props, state: self.state)
    
    if let layoutHash = layoutHash {
      // cache enabled, let's see if we have something cached
      if let frames = LayoutsCache.shared.getCachedLayout(layoutHash: layoutHash,
                                                     nativeViewFrame: frame,
                                                          multiplier: multiplier,
                                                     nodeDescription: self.description) {
        
        return self.getFramedChildren(fromChildren: children, frames: frames)
      }
    }
    
    // no cache enabled or no layout cached yet
    container.initialize()
    type(of: description).anyLayout(views: container, props: self.description.props, state: self.state)
    let frames = container.frames
    
    if let layoutHash = layoutHash {
      
      // save only if layout cache is enabled
      LayoutsCache.shared.cacheLayout(layoutHash: layoutHash,
                                 nativeViewFrame: frame,
                                      multiplier: multiplier,
                                 nodeDescription: self.description,
                                          frames: frames)
    }
    
    return self.getFramedChildren(fromChildren: children, frames: frames)
  }
  
  private func getFramedChildren(fromChildren children: [AnyNodeDescription], frames: [String: CGRect]) -> [AnyNodeDescription] {
    return children.map {
      var newChild = $0
      
      if let key = newChild.key {
        if let frame = frames[key] {
          newChild.frame = frame
        }
      }
      
      if var n = newChild as? AnyNodeWithChildrenDescription {
        n.children = self.getFramedChildren(fromChildren: n.children, frames: frames)
        return n as AnyNodeDescription
        
      } else {
        return newChild
      }
    }
  }
}

public extension AnyNode {
  public var plasticMultipler: CGFloat {
    
    guard let description = self.anyDescription as? PlasticNodeDescriptionWithReferenceSize else {
      return self.parent?.plasticMultipler ?? 0.0
    }
    
    let referenceSize = type(of: description).referenceSize
    let currentSize = self.anyDescription.frame
    
    let widthRatio = currentSize.width / referenceSize.width
    let heightRatio = currentSize.height / referenceSize.height
    return min(widthRatio, heightRatio)
    
  }
}
