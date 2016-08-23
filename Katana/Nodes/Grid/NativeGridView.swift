//
//  NativeCollectionView.swift
//  Katana
//
//  Created by Mauro Bolis on 23/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

private let CELL_IDENTIFIER = "KATANA_CELL_IDENTIFIER"

public class NativeGridView: UICollectionView {
  private weak var parentNode: AnyNode?
  private var katanaDelegate: GridDelegate?

  convenience init() {
    // TODO: handle this
    let layout = UICollectionViewLayout()
    self.init(frame: CGRect.zero, collectionViewLayout: layout)
  }
  
  override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    self.delegate = self
    self.dataSource = self
    
    self.register(NativeGridViewCell.self, forCellWithReuseIdentifier: CELL_IDENTIFIER)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(withParentNode parentNode: AnyNode, delegate: GridDelegate) {
    // TODO: maybe check for equality somehow here?
    // TODO: update layout here
    self.katanaDelegate = delegate
    self.parentNode = parentNode
    self.reloadData()
  }
}

extension NativeGridView: UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    if let delegate = self.katanaDelegate {
      return delegate.numberOfSections()
    }
    
    return 0
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let delegate = self.katanaDelegate {
      return delegate.numberOfRows(forSection: section)
    }
    
    return 0
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath) as! NativeGridViewCell
    
    if let parentNode = self.parentNode, let delegate = self.katanaDelegate {
      let description = delegate.nodeDescription(forRowAt: indexPath)
      cell.update(withParentNode: parentNode, description: description)
    }
    
    return cell
  }
}

extension NativeGridView: UICollectionViewDelegate {
}
