//
//  Reducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 08/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

protocol Reducer {
  associatedtype StateType: State
  static func reduce(action: Action, state: StateType?) -> StateType
}
