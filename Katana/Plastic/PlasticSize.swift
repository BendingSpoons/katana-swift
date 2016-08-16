//
//  PlasticSize.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

public struct PlasticSize: Equatable {
  let width: PlasticValue
  let height: PlasticValue
  
  static let zero = PlasticSize(0, 0)
  
  init(_ width: Float, _ height: Float) {
    self.width = PlasticValue(width)
    self.height = PlasticValue(height)
  }
  
  init(scalableWidth: Float, fixedWidth: Float, scalableHeight: Float, fixedHeight: Float) {
    self.width = PlasticValue(scalable: scalableWidth, fixed: fixedWidth)
    self.height = PlasticValue(scalable: scalableHeight, fixed: fixedHeight)
  }
  
  init(width: PlasticValue, height: PlasticValue) {
    self.width = width
    self.height = height
  }
  
  public func scale(_ multiplier: Float) -> CGSize {
    return CGSize(
      width: CGFloat(self.width.scale(multiplier)),
      height: CGFloat(self.height.scale(multiplier))
    )
  }
  
  public static func *(lhs: PlasticSize, rhs: Float) -> PlasticSize {
    return PlasticSize(width: lhs.width * rhs, height: lhs.height * rhs)
  }
  
  public static func +(lhs: PlasticSize, rhs: PlasticSize) -> PlasticSize {
    return PlasticSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }
  
  public static func /(lhs: PlasticSize, rhs: Float) -> PlasticSize {
    return PlasticSize(width: lhs.width / rhs, height: lhs.height / rhs)
  }
  
  public static func ==(lhs: PlasticSize, rhs: PlasticSize) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
  }
}
