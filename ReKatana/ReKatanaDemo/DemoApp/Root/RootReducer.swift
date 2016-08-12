//
//  RootReducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

enum RootReducer: Reducer {
  static func reduce(action: Action, state: RootState?) -> RootState {
    return RootState(
      albums: AlbumListReducer.reduce(action: action, state: state?.albums)
    )
  }
}
