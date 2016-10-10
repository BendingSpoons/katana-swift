//
//  KatanaTableView.swift
//  Katana
//
//  Created by Mauro Bolis on 22/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import UIKit
import Katana

/**
 TODO:
 - It should be fairly easy to prefetch cells with this approach, we should definitevely implement it (for iOS >= 10 only)
 - This may be a security hole, we should adress this issue with obfuscation
 */

private let CELLIDENTIFIER = "KATANA_CELLIDENTIFIER"

public class NativeTableView: UITableView {
  private(set) weak var parent: AnyNode?
  private(set) var katanaDelegate: TableDelegate?
  
  override public init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
   
    self.register(NativeTableViewCell.self, forCellReuseIdentifier: CELLIDENTIFIER)
    self.tableFooterView = UIView()
    self.separatorStyle = .none
    
    self.delegate = self
    self.dataSource = self
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(withparent parent: AnyNode, delegate: TableDelegate) {
    // TODO: maybe check for equality somehow here?
    self.katanaDelegate = delegate
    self.parent = parent
    self.reloadData()
  }
}


extension NativeTableView: UITableViewDataSource {
  public func numberOfSections(in tableView: UITableView) -> Int {
    if let delegate = self.katanaDelegate {
      return delegate.numberOfSections()
    }
    
    return 0
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let delegate = self.katanaDelegate {
      return delegate.numberOfRows(forSection: section)
    }
    
    return 0
  }
  
  @objc(tableView:cellForRowAtIndexPath:) public func tableView(_ tableView: UITableView,
                                                                cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CELLIDENTIFIER, for: indexPath) as! NativeTableViewCell
    
    if let parent = self.parent, let delegate = self.katanaDelegate {
      let description = delegate.nodeDescription(forRowAt: indexPath)
      cell.update(withparent: parent, description: description)
    }
    
    return cell
  }
  
  @objc(tableView:heightForRowAtIndexPath:) public func tableView(_ tableView: UITableView,
                                                     heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if let parent = self.parent, let delegate = self.katanaDelegate {
      let height = delegate.height(forRowAt: indexPath)
      return height.scale(parent.plasticMultipler)
    }
    
    return 0
  }
}


extension NativeTableView: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? NativeTableViewCell {
      cell.didTap(atIndexPath: indexPath)
    }
  }
}
