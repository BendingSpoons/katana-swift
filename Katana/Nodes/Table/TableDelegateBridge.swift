//
//  TableDelegateBridge.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

/**
  TODO:
    - It should be fairly easy to prefetch cells with this approach, we should definitevely implement it (for iOS >= 10 only)
    - We are forced to use NSObject here, this is a security hole, we should adress this issue with obfuscation
 */

class TableDelegateBridge: NSObject {
  unowned private let concreteNode: AnyNode
  private let delegate: TableDelegate
  
  init(concreteNode node: AnyNode, delegate: TableDelegate) {
    self.concreteNode = node
    self.delegate = delegate
  }
}

extension TableDelegateBridge: UITableViewDataSource {
  public func numberOfSections(in tableView: UITableView) -> Int {
    return self.delegate.numberOfSections()
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.delegate.numberOfRows(forSection: section)
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DEQUEUE_IDENTIFIER", for: indexPath)
    let description = self.delegate.nodeDescription(forRowAt: indexPath)
    
    description
      .node(parentNode: self.concreteNode, store: self.concreteNode.store)
      .render(container: cell)
    
    return cell
  }
  
  @objc(tableView:heightForRowAtIndexPath:) public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let height = self.delegate.height(forRowAt: indexPath)
    return height.scale(self.concreteNode.getPlasticMultiplier())
  }
}


extension TableDelegateBridge: UITableViewDelegate {
  
}
