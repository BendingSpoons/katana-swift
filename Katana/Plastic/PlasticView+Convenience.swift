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
    self.setLeft(view.left, insets.left)
    self.setRight(view.right, -insets.right)
  }
  
  public func fillVertically(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setTop(view.top, insets.top)
    self.setBottom(view.bottom, -insets.bottom)
  }
  
  public func fill(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setLeft(view.left, insets.left)
    self.setRight(view.right, -insets.right)
    self.setTop(view.top, insets.top)
    self.setBottom(view.bottom, -insets.bottom)
  }
  
  public func fill(top: Anchor,
                  left: Anchor,
                bottom: Anchor,
                 right: Anchor,
           aspectRatio: CGFloat = 1,
                insets: EdgeInsets = .zero) -> Void {
    
    self.setLeft(left, insets.left)
    self.setRight(right, -insets.right)
    self.setTop(top, insets.top)
    self.setBottom(bottom, -insets.bottom)
    
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
    self.setCenterX(left, offset)
  }
  
  public func centerBetween(top: Anchor, bottom: Anchor) -> Void {
    let offset: Value = .fixed((bottom.coordinate - top.coordinate) / 2.0)
    self.setCenterY(top, offset)
  }
  
  public func center(_ view: PlasticView) -> Void {
    self.centerX = view.centerX
    self.centerY = view.centerY
  }
  
  public func coverLeft(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setLeft(view.left, insets.left)
    self.setTop(view.top, insets.top)
    self.setBottom(view.bottom, -insets.bottom)
  }
  
  public func coverRight(_ view: PlasticView, insets: EdgeInsets = .zero) -> Void {
    self.setRight(view.right, -insets.right)
    self.setTop(view.top, insets.top)
    self.setBottom(view.bottom, -insets.bottom)
  }
  
  public func asHeader(_ view: PlasticView, insets: EdgeInsets = EdgeInsets.zero) -> Void {
    self.setLeft(view.left, insets.left)
    self.setRight(view.right, -insets.right)
    self.setTop(view.top, insets.top)
  }
  
  public func asFooter(_ view: PlasticView, insets: EdgeInsets = EdgeInsets.zero) -> Void {
    self.setLeft(view.left, insets.left)
    self.setRight(view.right, -insets.right)
    self.setBottom(view.bottom, -insets.bottom)
  }
}
