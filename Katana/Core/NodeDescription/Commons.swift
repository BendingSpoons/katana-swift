//
//  CommonProps.swift
//  Katana
//
//  Created by Luca Querella on 10/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import UIKit

public protocol Frameable {
  var frame: CGRect {get set}
  func frame(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> Self
  func frame(_: CGRect) -> Self  
}

public extension Frameable {
  func frame(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> Self {
    var copy = self
    copy.frame = CGRect(x: x, y: y, width: width, height: height)
    return copy
  }
  
  func frame(_ frame: CGRect) -> Self {
    var copy = self
    copy.frame = frame
    return copy
  }
  
  func frame(_ size: CGSize) -> Self {
    var copy = self
    copy.frame = CGRect(origin: CGPoint.zero, size: size)
    return copy
  }
}

public protocol Keyable {
  var key: String? { get set }
  func key<Key>(_ key: Key) -> Self
}

public extension Keyable {
  func key<Key>(_ key: Key) -> Self {
    var copy = self
    copy.key = "\(key)"
    return copy
  }
}

public struct EmptyProps: NodeProps, Keyable {
  public var key: String?
  public var frame: CGRect = CGRect.zero
  
  public static func == (lhs: EmptyProps, rhs: EmptyProps) -> Bool {
    return lhs.frame == rhs.frame
  }
  
  public init() {}
}

public struct EmptyState: NodeState {

  public static func == (lhs: EmptyState, rhs: EmptyState) -> Bool {
    return true
  }
  
  public init() {}
}
