//
//  Dispatchable.swift
//  Katana
//
//  Copyright © 2019 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 Protocol that marks something that can be actually dispatched into the `Store`.
 It doesn't have any particular requirement, and the protocol is actually used to
 simply mark a category of items. Currently the `Store` is able to manage 2 types
 of `Dispatchable`: `SideEffect`, `StateUpdater`.
 */
public protocol Dispatchable: CustomDebugStringConvertible {}

/// Implementation of the `CustomDebugStringConvertible` protocol
extension Dispatchable {
  public var debugDescription: String {
    return String(reflecting: type(of: self))
  }
}
