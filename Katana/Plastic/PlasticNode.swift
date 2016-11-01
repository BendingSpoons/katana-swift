//
//  PlasticNode.swift
//  Katana
//
//  Created by Mauro Bolis on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public class PlasticNode<Description: PlasticNodeDescription>: Node<Description> {
  
  override public func processedChildrenDescriptionsBeforeDraw(_ childrenDescriptions: [AnyNodeDescription])
    -> [AnyNodeDescription] {
    let childrenDescriptions = super.processedChildrenDescriptionsBeforeDraw(childrenDescriptions)
    let updatedFrames = self.updatedFrames(for: childrenDescriptions)
    let newChildrenDescriptions = self.updatedChildrenDescriptionsWithNewFrames(childrenDescriptions: childrenDescriptions,
                                                                                newFrames: updatedFrames)
    return newChildrenDescriptions
  }
  
  func updatedFrames(for childrenDescriptions: [AnyNodeDescription]) -> [String: CGRect] {
    let multiplier = self.plasticMultipler
    let frame = self.description.props.frame
    let container = ViewsContainer<Description.Keys>(nativeViewFrame: frame,
                                                     children: childrenDescriptions,
                                                     multiplier: multiplier)
    let selfType = type(of: description)
    let layoutHash = selfType.layoutHash(props: self.description.props, state: self.state)
    
    // check if we have cache enabled, and there is a layout cached
    if let layoutHash = layoutHash, let newFrames = LayoutsCache.shared.getCachedLayout(layoutHash: layoutHash,
                                                                                        nativeViewFrame: frame,
                                                                                        multiplier: multiplier,
                                                                                        nodeDescription: self.description) {
        return newFrames
    }
    
    // no cache enabled or no layout cached yet
    container.initialize()
    type(of: description).anyLayout(views: container, props: self.description.props, state: self.state)
    let newFrames = container.frames
    if let layoutHash = layoutHash {
      // save only if layout cache is enabled
      LayoutsCache.shared.cacheLayout(layoutHash: layoutHash,
                                      nativeViewFrame: frame,
                                      multiplier: multiplier,
                                      nodeDescription: self.description,
                                      frames: newFrames)
    }
    return newFrames
  }
  
  private func updatedChildrenDescriptionsWithNewFrames(childrenDescriptions: [AnyNodeDescription],
                                                        newFrames: [String: CGRect]) -> [AnyNodeDescription] {
    return childrenDescriptions.map {
      var newChildDescription = $0
      
      if let key = newChildDescription.key {
        if let frame = newFrames[key] {
          newChildDescription.frame = frame
        }
      }
      
      if var n = newChildDescription as? AnyNodeDescriptionWithChildren {
        n.children = self.updatedChildrenDescriptionsWithNewFrames(childrenDescriptions: n.children, newFrames: newFrames)
        return n as AnyNodeDescription
      } else {
        return newChildDescription
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
