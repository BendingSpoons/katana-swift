//
//  State.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Foundation

/**
 Protocol for the state of the applications.
 In Katana, all the relevant application information should be placed in a single
 struct that has to implement the `State` protocol.
 */
public protocol State {
  /**
   Returns the initial configuration of the `State` implementation.
   It is used by Katana to create the very initial configuration of the application.
   */
  init()
}
