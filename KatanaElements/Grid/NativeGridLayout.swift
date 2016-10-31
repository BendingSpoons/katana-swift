//
//  FlowGridLayout.swift
//  Katana
//
//  Created by Mauro Bolis on 23/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana

private enum LayoutType {
  case variableNumberCellsOnline, constantNumberCellsOnline
}

class NativeGridLayout: UICollectionViewFlowLayout {
  fileprivate var layoutType: LayoutType
  var plasticMultiplier: CGFloat?
  
  override public init() {
    self.layoutType = .variableNumberCellsOnline
    super.init()
  }
  
  func update(withProps props: GridProps, multiplier: CGFloat) {
    self.plasticMultiplier = multiplier
    
    if let cellAspectRatio = props.cellAspectRatio {
      self.cellAspectRatio = cellAspectRatio
    }

    if let numberOfCellsOnline = props.numberOfCellsOnline {
      self.numberOfCellsOnline = numberOfCellsOnline
    }

    if let minimumCellLenghtOnline = props.minimumCellLenghtOnline {
      self.minimumCellLenghtOnline = minimumCellLenghtOnline
    }
    
    if let sectionInsets = props.sectionInsets {
      self.scalableSectionInsets = sectionInsets
    }
    
    if let lineInsets = props.lineInsets {
      self.scalableLineSpacing = lineInsets
    }
    
    if let cellSpacing = props.cellSpacing {
      self.scalableInterCellSpacing = cellSpacing
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var cellAspectRatio: CGFloat = 1.0 {
    willSet(newValue) {
      precondition(newValue > 0, "The cell aspect ratio must be greater than zero.")
    }
  }
  
  var numberOfCellsOnline = 1 {
    willSet(newValue) {
      precondition(newValue > 0, "The number of cells on a line cannot be zero.")
    }
    
    didSet {
      self.layoutType = .constantNumberCellsOnline
    }
  }
  
  var minimumCellLenghtOnline: Value = .scalable(60.0) {
    willSet(newValue) {
      precondition(newValue.unscaledValue > 0, "The minimum cell length must be positive.")
    }
    
    didSet {
      self.layoutType = .variableNumberCellsOnline
    }
  }
  
  var scalableSectionInsets: EdgeInsets = .zero
  var scalableLineSpacing: Value = .zero
  var scalableInterCellSpacing: Value = .zero
}

extension NativeGridLayout {
  override func prepare() {
    super.prepare()
    
    guard let multiplier = self.plasticMultiplier else {
      preconditionFailure("Plastic multiplier is not yet available")
    }
    
    self.sectionInset = self.scalableSectionInsets.scale(by: multiplier)
    self.minimumLineSpacing = self.scalableLineSpacing.scale(by: multiplier)
    self.minimumInteritemSpacing = self.scalableInterCellSpacing.scale(by: multiplier)
    self.itemSize = self.scaledCellSize()
  }
  
  private func scaledCellSize() -> CGSize {
    guard let collectionView = self.collectionView, let multiplier = self.plasticMultiplier else {
      return .zero
    }
    
    let viewSize = collectionView.frame.size
    let horizontalInsetSum = self.sectionInset.left + self.sectionInset.right
    let verticalInsetSum = self.sectionInset.top + self.sectionInset.bottom
    let totalGapLength = CGFloat(numberOfCellsOnline - 1) * self.minimumInteritemSpacing
    
    switch (self.layoutType, self.scrollDirection) {
    case (.variableNumberCellsOnline, .vertical):
      let scaledMinimumCellLength = self.minimumCellLenghtOnline.scale(by: multiplier)
      
      let cellsNumber = max(1, floor(
        (viewSize.width - horizontalInsetSum + self.minimumInteritemSpacing) /
        (scaledMinimumCellLength + self.minimumInteritemSpacing)
      ))
      
      let totalGapLength = CGFloat(cellsNumber) * self.minimumInteritemSpacing
      let viewWidthWithoutGaps = viewSize.width - totalGapLength
      
      let width = viewWidthWithoutGaps / CGFloat(cellsNumber)
      let height = width / self.cellAspectRatio
      return CGSize(width: floor(width), height: floor(height))
      
      
    case (.variableNumberCellsOnline, .horizontal):
      let scaledMinimumCellLength = self.minimumCellLenghtOnline.scale(by: multiplier)
      
      let cellsNumber = max(1, floor(
          (viewSize.height - verticalInsetSum + self.minimumInteritemSpacing) /
          (scaledMinimumCellLength + self.minimumInteritemSpacing)
        ))
      
      let totalGapLength = CGFloat(cellsNumber) * self.minimumInteritemSpacing
      let viewHeightWithoutGaps = viewSize.height - totalGapLength
      
      let height = viewHeightWithoutGaps / CGFloat(cellsNumber)
      let width = height * self.cellAspectRatio
      return CGSize(width: floor(width), height: floor(height))
      
    
    case (.constantNumberCellsOnline, .vertical):
      let viewWidthWithoutGaps = viewSize.width - totalGapLength - horizontalInsetSum
      let width = viewWidthWithoutGaps / CGFloat(self.numberOfCellsOnline)
      let height = width / self.cellAspectRatio
      return CGSize(width: floor(width), height: floor(height))
      
    case (.constantNumberCellsOnline, .horizontal):
      let viewHeightWithoutGaps = viewSize.height - totalGapLength - verticalInsetSum
      let height = viewHeightWithoutGaps / CGFloat(self.numberOfCellsOnline)
      let width = height * self.cellAspectRatio
      return CGSize(width: floor(width), height: floor(height))
    }
    
  }
}
