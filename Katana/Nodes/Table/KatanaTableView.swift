//
//  KatanaTableView.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit

/**
 TODO:
 - It should be fairly easy to prefetch cells with this approach, we should definitevely implement it (for iOS >= 10 only)
 - This may be a security hole, we should adress this issue with obfuscation
 */

private let CELL_IDENTIFIER = "KATANA_CELL_IDENTIFIER"

public class KatanaTableView: UITableView {
  private weak var parentNode: AnyNode?
  private var katanDelegate: TableDelegate?
  
  override public init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
   
    self.register(KatanaTableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
    self.tableFooterView = UIView()
    self.separatorStyle = .none
    
    self.delegate = self
    self.dataSource = self
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(withParentNode parentNode: AnyNode, delegate: TableDelegate) {
    // TODO: maybe check for equality somehow here?
    self.katanDelegate = delegate
    self.parentNode = parentNode
    self.reloadData()
  }
}


extension KatanaTableView: UITableViewDataSource  {
  @objc(numberOfSectionsInTableView:) public func numberOfSections(in tableView: UITableView) -> Int {
    if let delegate = self.katanDelegate {
      return delegate.numberOfSections()
    }
    
    return 0
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let delegate = self.katanDelegate {
      return delegate.numberOfRows(forSection: section)
    }
    
    return 0
  }
  
  @objc(tableView:cellForRowAtIndexPath:) public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as! KatanaTableViewCell
    
    if let parentNode = self.parentNode, let delegate = self.katanDelegate {
      let description = delegate.nodeDescription(forRowAt: indexPath)
      cell.update(withParentNode: parentNode, description: description)
    }
    
    return cell
  }
  
  @objc(tableView:heightForRowAtIndexPath:) public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if let parentNode = self.parentNode, let delegate = self.katanDelegate {
      let height = delegate.height(forRowAt: indexPath)
      return height.scale(parentNode.getPlasticMultiplier())
    }
    
    return 0
  }
}


extension KatanaTableView: UITableViewDelegate {}
