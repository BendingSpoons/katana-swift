//
//  Array+Plastic.swift
//  Katana
//
//  Created by Mauro Bolis on 17/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

extension Array where Element: PlasticView {
 
  public func centerBetween(left: Anchor, right: Anchor, spacings s: [Value]? = nil) -> Void {
    let spacings = s ?? (0..<self.count - 1).map { _ in .zero }
    
    guard spacings.count == self.count - 1 else {
      fatalError("The number of spacings values should be equal to the number of views minus 1")
    }
    
    let firstView = self[0]
    let otherViews = self.dropFirst()
    var totalWidth = firstView.width.unscaledValue
    
    let scaledSpacings = zip(otherViews, spacings).map { (view, spacing) -> CGFloat in
      let scaled = view.scaleValue(spacing)
      totalWidth = totalWidth + scaled + view.frame.size.width
      return scaled
    }
    
    let leftmostOffset = (right.coordinate - left.coordinate - totalWidth) / 2.0
    firstView.setLeft(left, Value.fixed(leftmostOffset))
    
    for (index, view) in otherViews.enumerated() {
      let leftwardView = self[index] // take prev view
      let scaledSpacing = scaledSpacings[index]
      let anchor = Anchor(kind: .right, view: leftwardView)
      view.setLeft(anchor, .fixed(scaledSpacing))
    }
  }
  
  public func centerBetween(top: Anchor, bottom: Anchor, spacings s: [Value]? = nil) -> Void {
    let spacings = s ?? (0..<self.count - 1).map { _ in .zero }
    
    guard spacings.count == self.count - 1 else {
      preconditionFailure("The number of spacings values should be equal to the number of views minus 1")
    }
    
    let firstView = self[0]
    let otherViews = self.dropFirst()
    var totalHeight = firstView.height.unscaledValue
    
    
    let scaledSpacings = zip(otherViews, spacings).map { (view, spacing) -> CGFloat in
      let scaled = firstView.scaleValue(spacing)
      totalHeight = totalHeight + scaled + view.height.unscaledValue
      return scaled
    }
    
    let upmostOffset = (bottom.coordinate - top.coordinate - totalHeight) / 2.0
    firstView.setTop(top, .fixed(upmostOffset))
    
    for (index, view) in otherViews.enumerated() {
      let upperView = self[index]
      let scaledSpacing = scaledSpacings[index]
      let anchor = Anchor(kind: .bottom, view: upperView)
      view.setTop(anchor, .fixed(scaledSpacing))
    }
  }
  
  public func fill(left: Anchor,
                  right: Anchor,
                 insets: EdgeInsets = .zero,
             spacings s: [Value]? = nil,
               widths w: [CGFloat]? = nil) -> Void {
    
    let spacings = s ?? (0..<self.count - 1).map { _ in .zero }
    let widths = w ?? (0..<self.count).map { _ in 1 }
    
    guard spacings.count == self.count - 1 else {
      preconditionFailure("The number of spacings values should be equal to the number of views minus 1")
    }
    
    guard widths.count == self.count else {
      preconditionFailure("The number of widths should be equal to the number of views")
    }
    
    let firstView = self[0]
    
    // Determine the total available width excluding the spacings
    let insetsSpacing = firstView.scaleValue(insets.left) + firstView.scaleValue(insets.right)
    let totalSpacing = spacings.reduce(insetsSpacing, {
      return $0 + firstView.scaleValue($1)
    })
    
    let totalAvailableWidth = right.coordinate - left.coordinate - totalSpacing
    
    // Determine each view's width to preserve proportions within available width
    let totalReferenceWidth = widths.reduce(0, +)
    
    for (index, view) in self.enumerated() {
      let referenceWidth = widths[index]
      let width = referenceWidth / totalReferenceWidth * totalAvailableWidth
      view.width = .fixed(width)
      
      if index == 0 {
        view.setLeft(left, insets.left)
      
      } else {
        let leftwardView = self[index-1]
        let spacing = spacings[index-1]
        view.setLeft(leftwardView.right, spacing)
      }
    }
  }
  
  public func fill(top: Anchor,
                bottom: Anchor,
                insets: EdgeInsets = .zero,
            spacings s: [Value]? = nil,
             heights h: [CGFloat]? = nil) -> Void {
    
    let spacings = s ?? (0..<self.count - 1).map { _ in .zero }
    let heights = h ?? (0..<self.count).map { _ in 1 }
    
    guard spacings.count == self.count - 1 else {
      preconditionFailure("The number of spacings values should be equal to the number of views minus 1")
    }
    
    guard heights.count == self.count else {
      preconditionFailure("The number of heights should be equal to the number of views")
    }
    
    let firstView = self[0]
    
    // Determine the total available width excluding the spacings
    let insetsSpacing = firstView.scaleValue(insets.top) + firstView.scaleValue(insets.bottom)
    let totalSpacing = spacings.reduce(insetsSpacing, {
      return $0 + firstView.scaleValue($1)
    })
    
    let totalAvailableHeight = bottom.coordinate - top.coordinate - totalSpacing
    
    // Determine each view's width to preserve proportions within available width
    let totalReferenceHeight = heights.reduce(0, +)
    
    for (index, view) in self.enumerated() {
      let referenceHeight = heights[index]
      let height = referenceHeight / totalReferenceHeight * totalAvailableHeight
      view.height = .fixed(height)
      
      if index == 0 {
        view.setTop(top, insets.top)
      
      } else {
        let upperView = self[index-1]
        let spacing = spacings[index - 1]
        view.setTop(upperView.bottom, spacing)
      }
    }
  }
}
