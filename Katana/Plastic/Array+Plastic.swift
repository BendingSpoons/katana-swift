//
//  Array+Plastic.swift
//  Katana
//
//  Created by Mauro Bolis on 17/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

/// Utilities methods for Array of `PlasticView` instances
extension Array where Element: PlasticView {
  
  /**
   Centers the view instances in the array together with a collection of inter-view spacings horizontally so that
   their sizes, top edges and bottom edges are preserved.
   
   - parameter left:     the left view anchor used for the horizontal centering
   - parameter right:    the right view anchor used for the horizontal centering
   - parameter spacings: individual spacings to use between the views.
                         Must be an array of N-1 `Value` instances where N is the number
                         of views in the view array. If `nil`, an array of `Value.zero` is used instead
   
  */
  public func centerBetween(left: Anchor, right: Anchor, spacings: [Value]? = nil) -> Void {
    let spacings = spacings ?? (0..<self.count - 1).map { _ in .zero }
    
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
    firstView.setLeft(left, offset: Value.fixed(leftmostOffset))
    
    for (index, view) in otherViews.enumerated() {
      let leftwardView = self[index] // take prev view
      let scaledSpacing = scaledSpacings[index]
      let anchor = Anchor(kind: .right, view: leftwardView)
      view.setLeft(anchor, offset: .fixed(scaledSpacing))
    }
  }
  
  /**
   Centers the view instances in the array together with a collection of inter-view spacings vertically so that
   their sizes, left edges and right edges are preserved.
   
   - parameter left:     the top view anchor used for the vertical centering
   - parameter right:    the bottom view anchor used for the vertical centering
   - parameter spacings: individual spacings to use between the views.
                         Must be an array of N-1 `Value` instances where N is the number
                         of views in the view array. If `nil`, an array of `Value.zero` is used instead
   
  */
  public func centerBetween(top: Anchor, bottom: Anchor, spacings: [Value]? = nil) -> Void {
    let spacings = spacings ?? (0..<self.count - 1).map { _ in .zero }
    
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
    firstView.setTop(top, offset: .fixed(upmostOffset))
    
    for (index, view) in otherViews.enumerated() {
      let upperView = self[index]
      let scaledSpacing = scaledSpacings[index]
      let anchor = Anchor(kind: .bottom, view: upperView)
      view.setTop(anchor, offset: .fixed(scaledSpacing))
    }
  }
  
  /**
   Fills the horizontal space between two view anchors with the view instances in the array given a collection of
   inter-view spacings and insets. The final widths of the views will be determined by a collection of relational view
   widths.
   
   - parameter left:     the left view anchor for the horizontal distribution of the views
   - parameter right:    the right view anchor for the horizontal distribution of the views
   - parameter insets:   the insets for the left and right view anchors. The default value is `.zero`
   - parameter spacings: a collection of `Value` intances used to calculate the spacings between the views.
                         Must be an array of N-1 `Value` instances where N is the number
                         of views in the view array. If `nil`, an array of `Value.zero` is used instead
   - parameter widths:   a collection of CGFloats that are the view widths in relation
                         to eachother. For example, by passing `[1, 2]` the method will give to the second
                         view a width that is two times the width of the first view.
                         Must contain N values where N is the number of views in the array. If `nil` all the views
                         will have the same width
   
  */
  public func fill(left: Anchor,
                   right: Anchor,
                   insets: EdgeInsets = .zero,
                   spacings: [Value]? = nil,
                   widths: [CGFloat]? = nil) -> Void {
    
    let spacings = spacings ?? (0..<self.count - 1).map { _ in .zero }
    let widths = widths ?? (0..<self.count).map { _ in 1 }
    
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
        view.setLeft(left, offset: insets.left)
      
      } else {
        let leftwardView = self[index-1]
        let spacing = spacings[index-1]
        view.setLeft(leftwardView.right, offset: spacing)
      }
    }
  }
  
  /**
   Fills the vertical space between two view anchors with the view instances in the array given a collection of
   inter-view spacings and insets. The final heights of the array views will be determined by a collection of relational view
   heights.
   
   - parameter top:      the top view anchor for the vertical distribution of the views
   - parameter bottom:   the bottom view anchor for the vertical distribution of the views
   - parameter insets:   the insets for the top and bottom view anchors. The default value is `.zero`
   - parameter spacings: a collection of `Value` intances used to calculate the spacings between the views.
                         Must be an array of N-1 `Value` instances where N is the number
                         of views in the view array. If `nil`, an array of `Value.zero` is used instead
   - parameter heights:  a collection of CGFloats that are the view heights in relation
                         to eachother. For example, by passing `[1, 2]` the method will give to the second
                         view an height that is two times the height of the first view.
                         Must contain N values where N is the number of views in the array. If `nil` all the views
                         will have the same height
   */
  public func fill(top: Anchor,
                bottom: Anchor,
                insets: EdgeInsets = .zero,
                spacings: [Value]? = nil,
                heights: [CGFloat]? = nil) -> Void {
    
    let spacings = spacings ?? (0..<self.count - 1).map { _ in .zero }
    let heights = heights ?? (0..<self.count).map { _ in 1 }
    
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
        view.setTop(top, offset: insets.top)
      
      } else {
        let upperView = self[index-1]
        let spacing = spacings[index - 1]
        view.setTop(upperView.bottom, offset: spacing)
      }
    }
  }
}
