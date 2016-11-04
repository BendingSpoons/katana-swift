//
//  PlasticView+Convenience.swift
//  Katana
//
//  Created by Mauro Bolis on 17/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit


extension PlasticView {
  public func fillHorizontally(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setRight(view.right, offset: -insets.right)
  }
  
  public func fillVertically(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setTop(view.top, offset: insets.top)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
  
  public func fill(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setRight(view.right, offset: -insets.right)
    self.setTop(view.top, offset: insets.top)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
  
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
  
  public func centerBetween(left: Anchor, right: Anchor) -> Void {
    let offset: Value = .fixed((right.coordinate - left.coordinate) / 2.0)
    self.setCenterX(left, offset: offset)
  }
  
  public func centerBetween(top: Anchor, bottom: Anchor) -> Void {
    let offset: Value = .fixed((bottom.coordinate - top.coordinate) / 2.0)
    self.setCenterY(top, offset: offset)
  }
  
  public func center(_ view: PlasticView) -> Void {
    self.centerX = view.centerX
    self.centerY = view.centerY
  }
  
  public func coverLeft(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setTop(view.top, offset: insets.top)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
  
  public func coverRight(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setRight(view.right, offset: -insets.right)
    self.setTop(view.top, offset: insets.top)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
  
  public func asHeader(_ view: PlasticView, insets: EdgeInsets = EdgeInsets.zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setRight(view.right, offset: -insets.right)
    self.setTop(view.top, offset: insets.top)
  }
  
  public func asFooter(_ view: PlasticView, insets: EdgeInsets = EdgeInsets.zero) -> Void {
    self.setLeft(view.left, offset: insets.left)
    self.setRight(view.right, offset: -insets.right)
    self.setBottom(view.bottom, offset: -insets.bottom)
  }
}
