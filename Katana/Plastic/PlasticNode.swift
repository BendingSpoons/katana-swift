//
//  PlasticNode.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
  Subclass of `Node` that implements all the logic needed to use the Plastic layout system.
 
  - seeAlso: `PlasticNodeDescription`
*/
public class PlasticNode<Description: PlasticNodeDescription>: Node<Description> {
  /**
   This method implements the logic to invoke the layout logic provided by Plastic
   
   - parameter children: The children to process
   - returns: the processed children
   
   - seeAlso: `Node`, `processedChildrenDescriptionsBeforeDraw(:)` method
  */
  override public func processedChildrenDescriptionsBeforeDraw(_ childrenDescriptions: [AnyNodeDescription])
    -> [AnyNodeDescription] {
    let childrenDescriptions = super.processedChildrenDescriptionsBeforeDraw(childrenDescriptions)
    let updatedFrames = self.updatedFrames(for: childrenDescriptions)
    let newChildrenDescriptions = self.updatedChildrenDescriptionsWithNewFrames(childrenDescriptions: childrenDescriptions,
                                                                                newFrames: updatedFrames)
    return newChildrenDescriptions
  }
  
  /**
   Calculates the frames for the given node description.
   This method basically invokes the `layout` method of `PlasticNodeDescription`
   
   - parameter childrenDescriptions: the children descriptions for which we need to calculate the frame
   - returns: a dictionary where the key is the key is the description key and the value
              is the frame that has been calculated for it
  */
  private func updatedFrames(for childrenDescriptions: [AnyNodeDescription]) -> [String: CGRect] {
    let multiplier = self.plasticMultiplier
    let frame = self.description.props.frame
    let container = ViewsContainer<Description.Keys>(nativeViewFrame: frame,
                                                     childrenDescriptions: childrenDescriptions,
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
  
  /**
   Updates the given node descriptions with the provided frames.
  
   - parameter childrenDescriptions: the children descriptions to update
   - parameter newFrames:            the frame to assign to the descriptions
   - returns: the updated descriptions
  */
  private func updatedChildrenDescriptionsWithNewFrames(childrenDescriptions: [AnyNodeDescription],
                                                        newFrames: [String: CGRect]) -> [AnyNodeDescription] {
    return childrenDescriptions.map {
      var newChildDescription = $0
      
      if let key = newChildDescription.anyProps.key {
        if let frame = newFrames[key] {
          var newProps = newChildDescription.anyProps
          newProps.frame = frame
          newChildDescription = type(of: newChildDescription).init(anyProps: newProps)
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
  /**
   The Plastic multiplier that will be used in the current `Node`. If the description associated with the node
   implements the `PlasticReferenceSizeable`, then the multiplier is calculated using the
   current node information (e.g., the reference size and the current size). In any other case, the method
   will request the parent plastic multiplier
   
   - seeAlso: `PlasticReferenceSizeable`
  */
  public var plasticMultiplier: CGFloat {
    
    guard let description = self.anyDescription as? PlasticReferenceSizeable else {
      return self.parent?.plasticMultiplier ?? 0.0
    }
    
    let referenceSize = type(of: description).referenceSize
    let currentSize = self.anyDescription.anyProps.frame
    
    let widthRatio = currentSize.width / referenceSize.width
    let heightRatio = currentSize.height / referenceSize.height
    return min(widthRatio, heightRatio)
    
  }
}
