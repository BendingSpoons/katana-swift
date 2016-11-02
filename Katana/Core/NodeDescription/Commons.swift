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
}

public protocol Keyable {
  var key: String? { get set }
  mutating func setKey<K>(_ key: K)
}

public extension Keyable {
  public mutating func setKey<Key>(_ key: Key) {
    self.key = "\(key)"
  }
}

public protocol Childrenable {
  var children: [AnyNodeDescription] { get set }
}

public struct EmptyProps: NodeProps, Keyable {
  public var key: String?
  public var frame: CGRect = CGRect.zero
  
  public static func == (lhs: EmptyProps, rhs: EmptyProps) -> Bool {
    return
      lhs.frame == rhs.frame &&
      lhs.key == rhs.key
  }
  
  public init() {}
}

public struct EmptyState: NodeState {
  public static func == (lhs: EmptyState, rhs: EmptyState) -> Bool {
    return true
  }
  
  public init() {}
}
