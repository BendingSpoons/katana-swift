//
//  Dispatchable.swift
//  Katana
//
//  Copyright © 2018 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.
//

import Foundation

public protocol Dispatchable: CustomDebugStringConvertible {}

/// Implementation of the `CustomDebugStringConvertible` protocol
public extension Dispatchable {
  public var debugDescription: String {
    return String(reflecting: type(of: self))
  }
}
