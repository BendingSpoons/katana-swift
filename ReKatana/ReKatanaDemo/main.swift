//
//  main.swift
//  ReKatanaDemo
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

/*
  
 This is a real world exaple of how Katana-Redux can be used.
 It mimics the Photo Vault logic, but without the UI and by mocking somethings (e.g., get images from the disk/cameraroll/camera).
 
 The application is CLI based and very minimal. The only purpose here is to test the library in a near-real-world case
 
 Features
  - create a new album [DONE]
  - list albums [DONE]
  
 - add new photo to the album [TODO]
    - from camera roll [TODO]
    - from camera [TODO]
 
 - add new video to the album [TODO]
   - from camera roll [TODO]
   - from camera [TODO]

 - delete a photo from the album [TODO]
 - move the photo into another album [TODO]

 - delete a video from the album [TODO]
 - move the video into another album [TODO]
 */

// Let's create the store
let sagaMiddleware = SagaMiddleware.withSagaModules([], providersContainer: SagaProvidersContainer<RootReducer>.self)
let store = Store.init(RootReducer.self, middlewares: [sagaMiddleware])

repeat {
  let operation = askOperation()
  
  print("\n")

  switch operation {
  case .CreateAlbum:
    performCreateAlbum(store: store)
    
  case .ListAlbums:
    listAlbums(store: store)
  }
  
  print("------------------\n\n")
  
} while (true)
