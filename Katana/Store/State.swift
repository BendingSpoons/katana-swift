//
//  State.swift
//  Katana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

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
