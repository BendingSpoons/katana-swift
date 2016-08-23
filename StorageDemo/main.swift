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
 
 The application is CLI based and very minimal. The only purpose here is to test the library in a near-real-world case.
 
 
 Features
 - create a new album [DONE]
 - list albums [DONE]
 
 - add new photo to the album [TODO]
 - from camera roll [DONE]
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

/*
 First we create the saga middleware.
 Here we add all the saga modules that are used in the application and we create the store middleware
 that will fire the proper sagas actions are dispastched
 */
let sagaMiddleware = SagaMiddleware.withSagaModules(
  [
    AlbumReducerCreator(),
    ],
  providersContainer: DemoAppProvidersContainer.self)

/*
 Here we create the store.
 We need two things:
 1) The type of the root reducer
 2) the list of middlewares that will augment the store capabilities
 
 As you will notice, most of the generic types/classes that are available in the library use the root reducer for specialization.
 The root reducer, in fact, determinates the structure of the store' state since everything starts from it. Every reducer has an associated state type. And of course the root reducer has the root state associated. For this reason, by just specifying the root reducer, we are able to define the whole store behaviour (e.g., what is the state returned by get state, what is the model tree of the application and so on)
 */
let store = Store.init(RootReducer.self, middlewares: [sagaMiddleware])

/*
 Just logic here, nothing really related to the library.
 We ask for an operation and we invoke the propert method to perform it
 */
repeat {
  let operation = askOperation()
  
  print("\n")
  
  switch operation {
  case .createAlbum:
    performCreateAlbum(store: store)
    
  case .listAlbums:
    listAlbums(store: store)
    
  case .addPhotoCameraRoll:
    addPhotoCameraRoll(store: store)
  }
  
  print("------------------\n\n")
  
} while (true)
