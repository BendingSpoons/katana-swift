//
//  PlasticNode.swift
//  Katana
//
//  Created by Mauro Bolis on 19/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit


// A node that is able to provide a plastic multiplier
public protocol PlasticMultiplierProvider {
  func getPlasticMultiplier() -> CGFloat
}

// A node that is able to leverage plastic to trigger the layout of the nodes 
// returned from the NodeDescription
protocol PlasticNode: PlasticMultiplierProvider {
  associatedtype Description: NodeDescription
  
  var typedDescription: Description { get }
  weak var parentNode: AnyNode? { get }
  var state : Description.State { get }
  
  func applyLayout(to children: [AnyNodeDescription]) -> [AnyNodeDescription]
  func getPlasticMultiplier() -> CGFloat
}

extension PlasticNode {
  func applyLayout(to children: [AnyNodeDescription]) -> [AnyNodeDescription] {
    
    guard let description = self.typedDescription as? AnyPlasticNodeDescription else {
      // the node is not conforming to plastic, just return the children as is
      return children
    }
    
    let container = ViewsContainer(rootFrame: self.typedDescription.props.frame, children: children, multiplier: self.getPlasticMultiplier())
    description.dynamicType._layout(views: container, props: self.typedDescription.props, state: self.state)
    
    return self.getFramedChildren(fromChildren: children, usingContainer: container)
  }
  
  private func getFramedChildren(fromChildren children: [AnyNodeDescription], usingContainer container: ViewsContainer) -> [AnyNodeDescription] {
    
    return children.map {
      var newChild = $0
      
      if let key = newChild.key {
        // if key is not in container we would throw an exception anyway
        let frame = container[key]!.frame
        newChild.frame = frame
      }
      
      if var n = newChild as? AnyNodeWithChildrenDescription {
        n.children = self.getFramedChildren(fromChildren: n.children, usingContainer: container)
        return n as! AnyNodeDescription
        
      } else {
        return newChild
      }
    }
  }
  
  public func getPlasticMultiplier() -> CGFloat {
    guard let description = self.typedDescription as? ReferenceNodeDescription else {
      return self.parentNode?.getPlasticMultiplier() ?? 0.0
    }
    
    let referenceSize = description.dynamicType.referenceSize()
    let currentSize = self.typedDescription.frame
    
    let widthRatio = currentSize.width / referenceSize.width;
    let heightRatio = currentSize.height / referenceSize.height;
    return min(widthRatio, heightRatio);
  }
}
