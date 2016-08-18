//
//  RootReducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

/*
 This is the root reducer of the application.
 Since the root state is just a collection of state's slides, here we don't really do anything. The root state is created by composing the result of other reducers.
 */
enum RootReducer: Reducer {
  static func reduce(action: Action, state: RootState?) -> RootState {
    return RootState(
      albums: AlbumListReducer.reduce(action: action, state: state?.albums)
    )
  }
}
