//
//  AlbumListActions.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

let moduleName = "ALBUMLIST"

/*
 This is an action that manages a sync operation.
 Actually SyncActionCreator returns an action creator. An action creator is basically a function that returns the action. You can specify a name of the actin. It will be used for debugging and internally to determinate things like which reducer invoke in the ReduceCombiner.
 
 Scoping the action name with the module name is a best pratice to avoid naming collisions
 */
let AddAlbumAction = SyncActionCreator<String>(withName: "\(moduleName)/ADD_ALBUM")

/*
 It is a best pratice to define the action type after the action creator.
 The action type is used as a shortcut when you need to use the action as parameter (e.g., in the reducer)
 */
typealias AddAlbumActionType = SyncAction<String>


/*
 This action represents an asyn operations.
 An async operation is used together with a saga and is initially in a loading state.
 The saga performs some custom logic and then creates a new action which can either represent a completed state or an error one
 
 As you can see there are 3 generics.
 The first is the payload type of the action when it is loading.
 The second is the payload type when it is completed.
 The third when the the action is in the error state
 */
typealias AddPhotoCompletedPayload = (albumName: String, photo: Photo)
let AddPhotoCameraRollAction = AsyncActionCreator<String, AddPhotoCompletedPayload, Void>(withName: "\(moduleName)/ADD_PHOTO_CAMERA_ROLL")
typealias AddPhotoCameraRollActionType = AsyncAction<String, AddPhotoCompletedPayload, Void>
