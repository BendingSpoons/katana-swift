//
//  PlasticView+Convenience.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import UIKit

/// `PlasticView` helpers methods
extension PlasticView {
  /**
   Lets the view upon which this method is called fill out the width of the frame of another view using optional insets.
   The vertical position and height of the called-upon view remain unchanged.
   
   - parameter view:   the view whose frame should be filled horizontally
   - parameter insets: the insets to use when filling the view frame. Only the left and right insets are used.
  */
  public func fillHorizontally(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setRight(view.right, offset: -insets.right)
  }
  
  /**
   Lets the view upon which this method is called fill out the height of the frame of another view using optional
   insets. The horizontal position and width of the called-upon view remain unchanged.
   
   - parameter view:   the view whose frame should be filled vertically
   - parameter insets: the insets to use when filling the view frame. Only the left and right insets are used
  */
  public func fillVertically(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setTop(view.top, offset: insets.top)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
  
  /**
   Lets the view upon which this method is called fill out the frame of another using optional insets.
   
   - parameter view:   the view whose frame should be filled
   - parameter insets: the insets to use when filling the view frame
  */
  public func fill(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setRight(view.right, offset: -insets.right)
    self.setTop(view.top, offset: insets.top)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
  
  /**
   Lets the view upon which this method is called be stretched out between four separate view anchor positions while
   maintaining a certain aspect ratio. Optional insets can be used.
   
   - parameter left:        the left view anchor position that the called-upon view's left edge will be stretched towards
   - parameter right:       the right view anchor position that the called-upon view's right edge will be stretched towards
   - parameter top:         the top view anchor position that the called-upon view's top edge will be stretched towards
   - parameter bottom:      the bottom view anchor position that the called-upon view's bottom edge will be stretched towards
   - parameter aspectRatio: the aspect ratio that the called-upon view should maintain. Give as width devided by height.
                            Default value is 1
   - parameter insets:      the insets to use for the given view anchors
  */
  public func fill(top: Anchor,
                  left: Anchor,
                bottom: Anchor,
                 right: Anchor,
           aspectRatio: CGFloat = 1,
                insets: EdgeInsets = .zero) -> Void {
    
    self.setLeft(left, offset: insets.left)
    self.setRight(right, offset: -insets.right)
    self.setTop(top, offset: insets.top)
    self.setBottom(bottom, offset: -insets.bottom)
    
    let width = self.width.unscaledValue
    let height = self.height.unscaledValue
    
    if width / height < aspectRatio {
      self.centerBetween(top: top, bottom: bottom)
      self.height = Value.fixed(width / aspectRatio)
      
    } else {
      self.centerBetween(left: left, right: right)
      self.width = Value.fixed(height * aspectRatio)
    }
  }
  
  /**
   Centers the view upon which this method is called horizontally between two view anchors. The size, top edge and
   bottom edge of the view will remain the same.
   
   - parameter left:  the left view anchor to center the called-upon view in relation to
   - parameter right: the right view anchor to center the called-upon view in relation to
  */
  public func centerBetween(left: Anchor, right: Anchor) -> Void {
    let offset: Value = .fixed((right.coordinate - left.coordinate) / 2.0)
    self.setCenterX(left, offset: offset)
  }
  
  /**
   Centers the view upon which this method is called vertically between two view anchors. The size, left edge and
   right edge of the view will remain the same.
   
   - parameter top:      the top view anchor to center the called-upon view in relation to
   - parameter bottom:   the bottom view anchor to center the called-upon view in relation to
  */
  public func centerBetween(top: Anchor, bottom: Anchor) -> Void {
    let offset: Value = .fixed((bottom.coordinate - top.coordinate) / 2.0)
    self.setCenterY(top, offset: offset)
  }
  
  /**
   Centers the view upon which this method is called in the frame of another view.
   The size of the called-upon view will remain the same.
   
   - parameter view: the view to center the called-upon view in
  */
  public func center(_ view: PlasticView) -> Void {
    self.centerX = view.centerX
    self.centerY = view.centerY
  }
  
  /**
   Lets the view upon which this method is called have its top, left and bottom edges aligned to those of another view
   with some optional insets.
   
   - parameter view:   the view whose edges to align with
   - parameter insets: the insets to use when aligning edges
  */
  public func coverLeft(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setTop(view.top, offset: insets.top)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
  
  /**
   Lets the view upon which this method is called have its top, right and bottom edges aligned to those of another view
   with some optional insets.
   
   - parameter view:   the view whose edges to align with
   - parameter insets: the insets to use when aligning edges
  */
  public func coverRight(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setRight(view.right, offset: -insets.right)
    self.setTop(view.top, offset: insets.top)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
  
  /**
   Lets the view upon which this method is called have its left, top and right edges aligned to those of another view
   with some optional insets.
   
   - parameter view:   the view whose edges to align with
   - parameter insets: the insets to use when aligning edges
  */
  public func asHeader(_ view: PlasticView, insets: EdgeInsets = EdgeInsets.zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setRight(view.right, offset: -insets.right)
    self.setTop(view.top, offset: insets.top)
  }
  
  /**
   Lets the view upon which this method is called have its left, bottom and right edges aligned to those of another view
   with some optional insets.
   
   - parameter view:   the view whose edges to align with
   - parameter insets: the insets to use when aligning edges
  */
  public func asFooter(_ view: PlasticView, insets: EdgeInsets = EdgeInsets.zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setRight(view.right, offset: -insets.right)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
}
