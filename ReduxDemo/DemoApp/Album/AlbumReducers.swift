//
//  AlbumReducers.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

// this is added as a workaround of swift 3 but. It will be removed and you can use Saga instead
private typealias SagaP<ManagedAction: Action, RootReducer: Reducer, Providers: SagaProvidersContainer<RootReducer>> = (action: ManagedAction, getState: () -> RootReducer.StateType, dispatch: StoreDispatch, providers: Providers) -> Void


/*
 This is a saga, a function where we can add some business logic.
 In this case we will use a provider to take a photo from the camera roll and then send it to the reducer.
 
 We are using a asyncAction so we will receive only the action when it is in the pending state.
 Here is what we will do:
 
 - We will get the action in the pending state, it contains the album name
 - We invoke the camera roll provider, which will return a photo
 - We get the completed action, using the proper method
 - We will dispatch it, the reducer will change the state
 */
private let addPhotoCameraRoll: SagaP<AddPhotoCameraRollActionType, RootReducer, DemoAppProvidersContainer> = {
  action, getState, dispatch, providers in
  
  // extract the payload from the action
  guard let albumName = action.payload else {
    return
  }

  let photo = providers.cameraRoll.getPhotoFromCameraRoll()
  let completedAction = action.completedAction(payload: (albumName: albumName, photo: photo))
  dispatch(completedAction)
}


/*
 In Swift expression are not allowed at the top level.
 This means that we cannot write instructions in the file itself.
 That being said, SagaModule needs to perform some special operations during addSaga.
 
 As a workaround, we create a function, that performs the module initialization and returns it.
 We then call this function when we create the store.
 
 We should find a better way to handle this
 */
let AlbumReducerCreator = { () -> SagaModule in
  var module = SagaModule()
  module.addSaga(addPhotoCameraRoll, forActionCreator: AddPhotoCameraRollAction)
  
  return module
}
