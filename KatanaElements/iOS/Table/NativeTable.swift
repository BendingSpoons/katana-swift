//
//  NativeTable.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation
import UIKit
import Katana

private let cellIdentifier = "KATANA_CELLIDENTIFIER"

public class NativeTable: UITableView {
  private(set) weak var parent: AnyNode?
  private(set) var katanaDelegate: TableDelegate?
  
  override public init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
   
    self.register(NativeTableWrapperCell.self, forCellReuseIdentifier: cellIdentifier)
    self.tableFooterView = UIView()
    self.separatorStyle = .none
    
    self.delegate = self
    self.dataSource = self
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(withparent parent: AnyNode, delegate: TableDelegate) {
    self.parent = parent
    
    if let currentDelegate = self.katanaDelegate, currentDelegate.isEqual(to: delegate) {
      return
    }
    
    self.katanaDelegate = delegate
    self.reloadData()
  }
}


extension NativeTable: UITableViewDataSource {
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
  
  @objc(tableView:cellForRowAtIndexPath:)
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NativeTableWrapperCell
    
    if let parent = self.parent, let delegate = self.katanaDelegate {
      let description = delegate.cellDescription(forRowAt: indexPath)
      cell.update(withparent: parent, description: description)
    }
    
    return cell
  }
  
  @objc(tableView:heightForRowAtIndexPath:)
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if let delegate = self.katanaDelegate, let node = self.parent {
      let value = delegate.height(forRowAt: indexPath)
      return value.scale(by: node.plasticMultiplier)
    }
    
    return 0
  }
}


extension NativeTable: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! NativeTableWrapperCell
    cell.didTap(atIndexPath: indexPath)
  }
}
