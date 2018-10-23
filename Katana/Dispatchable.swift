//
//  Dispatchable.swift
//  Katana
//
//  Created by Mauro Bolis on 23/10/2018.
//

import Foundation

public protocol Dispatchable: CustomDebugStringConvertible {}

/// Implementation of the `CustomDebugStringConvertible` protocol
public extension Dispatchable {
  public var debugDescription: String {
    return String(reflecting: type(of: self))
  }
}
