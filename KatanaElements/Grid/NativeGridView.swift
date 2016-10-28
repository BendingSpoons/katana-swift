//
//  NativeCollectionView.swift
//  Katana
//
//  Created by Mauro Bolis on 23/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

private let CELLIDENTIFIER = "KATANA_CELLIDENTIFIER"

public class NativeGridView: UICollectionView {
  private(set) weak var parent: AnyNode?
  private(set) var katanaDelegate: GridDelegate?

  convenience init() {
    self.init(frame: CGRect.zero, collectionViewLayout: NativeGridLayout())
  }
  
  override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    
    self.delegate = self
    self.dataSource = self
    
    self.register(NativeGridViewCell.self, forCellWithReuseIdentifier: CELLIDENTIFIER)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(withParent parent: AnyNode, delegate: GridDelegate, props: GridProps) {
    // TODO: maybe check for equality somehow here?
    
    let layout = self.collectionViewLayout as! NativeGridLayout
    layout.update(withProps: props, multiplier: parent.plasticMultipler)
    self.collectionViewLayout = layout
    
    self.katanaDelegate = delegate
    self.parent = parent
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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLIDENTIFIER, for: indexPath) as! NativeGridViewCell
    
    if let parent = self.parent, let delegate = self.katanaDelegate {
      let description = delegate.nodeDescription(forRowAt: indexPath)
      cell.update(withparent: parent, description: description)
    }
    
    return cell
  }
}

extension NativeGridView: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? NativeGridViewCell {
      cell.didTap(atIndexPath: indexPath)
    }
  }
}
