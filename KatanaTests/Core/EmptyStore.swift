//
//  EmptyReducer.swift
//  Katana
//
//  Created by Mauro Bolis on 20/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation

@testable import Katana

struct EmptyAppState: State {}

enum EmptyReducer: Reducer {
  static func reduce(action: Action, state: EmptyAppState) -> EmptyAppState {
    return EmptyAppState()
  }
}
