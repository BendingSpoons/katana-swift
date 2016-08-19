//
//  addPhotoCameraRoll.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

func addPhotoCameraRoll(store: Store<RootReducer>) {
  
  let albums = store.getState().albums.list
  
  let question = albums.reduce("Pick an album:") { prev, current in
    let idx = albums.index(where: { $0 == current })! // bang is safe here ;)
    return prev + "\n\(idx)) name: \(current.name)"
  }
  
  let album = aksQuestion(question, error: "Invalid Choice", until: { (str: String) -> Album? in
    if let idx = Int(str) {
      if idx >= 0 && idx < albums.count {
        return albums[idx]
      }
    }
    
    return nil
  })
  
  store.dispatch(AddPhotoCameraRollAction.with(payload: album.name))
}
