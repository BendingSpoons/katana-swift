//
//  listAlbums.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

func listAlbums(store: Store<RootReducer>) {
  let state = store.getState()
  let albums = state.albums.list
  
  print("Album List:")
  
  albums.forEach { album in
    print("- \(album.name), \(album.photos.count) photo")
  }
}
