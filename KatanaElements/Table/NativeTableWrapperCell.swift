//
//  NativeTableWrapperCell.swift
//  Katana
//
//  Created by Mauro Bolis on 31/10/2016.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit
import Katana

class NativeTableWrapperCell: UITableViewCell {
  private var node: AnyNode?
  
  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.selectionStyle = .none
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(withparent parent: AnyNode, description: AnyNodeDescription) {
    var newDescription = description
    newDescription.frame = self.bounds
    
    if let node = self.node {
      if node.anyDescription.replaceKey == description.replaceKey {
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
    
    // Katana right now requires manual management of children
    // when we have tables/grids
    // let's first remove the node from the parent (if any)
    if let node = self.node {
      node.parent?.removeManagedChild(node: node)
    }
    
    // and then add a new node with the new description
    self.node = parent.addManagedChild(description: newDescription, container: self.contentView)
  }
  
  func didTap(atIndexPath indexPath: IndexPath) {
    // if we have a node, and the description is of the CellNodeDescription kind, then
    // we can automate the tap process
    if let node = self.node, let description = node.anyDescription as? AnyTableCell {
      let store = node.root?.store
      let dispatch =  store?.dispatch ?? { fatalError("\($0) cannot be dispatched. Store not available.") }
      type(of: description).anyDidTap(dispatch: dispatch, props: description.anyProps, indexPath: indexPath)
    }
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    
    // let's see if in our subviews there is a CellNativeView, which we can use
    // to properly update the state
    // it there is such view, it is the only subview of contentview
    if let view = self.contentView.subviews.first as? NativeTableCell {
      view.setHighlighted(highlighted)
    }
  }
  
  deinit {
    // on cell deinit, remove the node from the tree
    // again, this is a current Katana limitation and we need to manage
    // nodes manually
    if let node = self.node {
      node.parent?.removeManagedChild(node: node)
    }
  }
}
