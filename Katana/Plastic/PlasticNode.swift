//
//  PlasticNode.swift
//  Katana
//
//  Created by Mauro Bolis on 25/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public class PlasticNode<Description: PlasticNodeDescription>: Node<Description> {
  
  override func processChildrenBeforeDraw(_ children: [AnyNodeDescription]) -> [AnyNodeDescription] {
    let newChildren = super.processChildrenBeforeDraw(children)
    return self.applyLayout(to: newChildren, description: self.typedDescription)
  }
  
  func applyLayout(to children: [AnyNodeDescription], description: Description) -> [AnyNodeDescription] {
    let multiplier = self.plasticMultipler
    let frame = self.typedDescription.props.frame
    
    let container = ViewsContainer<Description.Keys>(rootFrame: frame, children: children, multiplier: multiplier)
    type(of: description).anyLayout(views: container, props: self.typedDescription.props, state: self.state)
    
    return self.getFramedChildren(fromChildren: children, usingContainer: container)
  }
  
  private func getFramedChildren(fromChildren children: [AnyNodeDescription], usingContainer container: ViewsContainer<Description.Keys>) -> [AnyNodeDescription] {
    
    return children.map {
      var newChild = $0
      
      if let key = newChild.key {
        // if key is not in container we would throw an exception anyway
        let enumKey = Description.Keys.init(rawValue: key as! Description.Keys.RawValue)!
        let frame = container[enumKey]!.frame
        newChild.frame = frame
      }
      
      if var n = newChild as? AnyNodeWithChildrenDescription {
        n.children = self.getFramedChildren(fromChildren: n.children, usingContainer: container)
        return n as AnyNodeDescription
        
      } else {
        return newChild
      }
    }
  }
}
