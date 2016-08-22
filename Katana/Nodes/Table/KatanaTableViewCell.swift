//
//  KatanaTableViewCell.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit

class KatanaTableViewCell: UITableViewCell {
  private var node: AnyNode? = nil
  
  func update(withParentNode parentNode: AnyNode, description: AnyNodeDescription) {
    // we need to pass the cell frame
    // here we are causing a second evaluation of the description
    // Is there any way to avoid this? Passing the frame to the delegate could be an option
    // but it is very very ugly
    var newDescription = description
    newDescription.frame = self.bounds
    
    
    if let node = self.node {
      if node.description.dynamicType == description.dynamicType {
        // we just need to let the node do its job
        try! node.update(description: newDescription)
        return
      }
    }
    
    // either we don't have a node or the description are not compatible
    // just create a new node
    for view in self.contentView.subviews {
      view.removeFromSuperview()
    }
    
    let newNode = newDescription.node(parentNode: parentNode, store: parentNode.store)
    self.node = newNode
    newNode.render(container: self.contentView)
  }
}
