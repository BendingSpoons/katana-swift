//
//  AlbumListReducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

private enum AddAlbum: SyncReducer {
  static func reduceSync(action: AddAlbumActionType, state: AlbumListState) -> AlbumListState {
    let newAlbum = Album(name: action.payload)
    
    return AlbumListState(list: state.list + [newAlbum])
  }
}



enum AlbumListReducer: ReducerCombiner {
  static let initialState = AlbumListState(list: [
    Album(name: "Default Album")
  ])

  static let reducers: [String: AnyReducer.Type] = [
    AddAlbumAction.actionName: AddAlbum.self
  ]
}
