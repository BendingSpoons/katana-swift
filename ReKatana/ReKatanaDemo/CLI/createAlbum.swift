//
//  createAlbum.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

/// Create a new album
func performCreateAlbum(store: Store<RootReducer>) {
  
  let albumName = aksQuestion("Insert album name", error: "Invalid Name", until: { (str: String) -> String? in
    if (str.isEmpty) {
      return nil
    }
    
    return str
  })
  
  store.dispatch(AddAlbumAction.with(payload: albumName))
  print(store.getState())
}
