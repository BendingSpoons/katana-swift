//
//  AlbumListReducer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

/*
 This is an exaple of sync reducer.
 A syncReducer is a special abstraction over reducer that allow you to manage actions that represents sync operations.
 The advantages over the plain standard reducer are:
 1) The action si already casted, you don't need to check whether the action with which the reduer is invoked is the one you want to manage
 
 2) The state is already defined. You don't need to manage optionals
 
 Remember that this kind of reducers, as well as the async counterpart, are meant to be used with ReducerCombiner
 */
private enum AddAlbum: SyncReducer {
  static func reduceSync(action: AddAlbumActionType, state: AlbumListState) -> AlbumListState {
    let newAlbum = Album(id: NSUUID().uuidString, name: action.payload, photos: [])
    
    return AlbumListState(list: state.list + [newAlbum])
  }
}

/*
 This is an async reducer.
 You can use to manage actions related to async operations.
 
 It has 3 (optionals) methods for the 3 possible states of the action: Loading, Completed and Error.
 You can which states you need to manage based on your application needs
 */
private enum AddPhoto: AsyncReducer {
  static func reduceCompleted(action: AddPhotoCameraRollActionType, state: AlbumListState) -> AlbumListState {
    
    guard let payload = action.completedPayload else {
      return state
    }
    
    // create the new album list
    // we search the album that should be updated and we update it
    let newAlbums = state.list.map { (album: Album) -> Album in
      if album.name == payload.albumName {
        return Album(
          id: album.id,
          name: album.name,
          photos: album.photos + [payload.photo]
        )
      }
      
      return album
    }
    
    return AlbumListState(list: newAlbums)
  }
}

/*
 This is a special reducer that combines different reducers for the same state slice.
 The pattern should be that all the reducers are defined as private in the file, and therefore not accesible from other files, and then there is a single reducer that combine all the reducers in a single one.
 */
enum AlbumListReducer: ReducerCombiner {
  /*
   The reducer combiner automatically manage the defaul state.
   They basically return the initial state when the state is not defined (usually, at the very beginning of the application)
  */
  static let initialState = AlbumListState(list: [
    Album(id: NSUUID().uuidString, name: "Default Album", photos: [])
  ])

  /*
   Here we combine the reducers.
   The key of the dictionary is the name of the action that will be managed. AddAlbumAction has a special property that allows you to avoid to write the plain string here. In this we avoid problems such as issues after a refactor or misspelling.
   
   The value is the reducer type
  */
  static let reducers: [String: AnyReducer.Type] = [
    AddAlbumAction.actionName: AddAlbum.self,
    AddPhotoCameraRollAction.actionName: AddPhoto.self
  ]
}
